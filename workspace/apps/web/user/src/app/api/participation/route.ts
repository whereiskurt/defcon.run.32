import { NextRequest, NextResponse } from 'next/server';
import { auth } from '@auth';
import { createActivity, deleteActivity, Participation } from '@defcon.run/web/db';
import { verifyCsrfToken } from '../util';
import { act } from 'react';

export async function DELETE(req: NextRequest, res: NextResponse) {
    const data = await req.json()
    const { csrfToken, payload } = data

    const session = await auth()
    if (!session || !session.user.email || !session.user.id) {
        return NextResponse.json({ message: "401 Unauthorized" }, { status: 401, })
    }
    if (!verifyCsrfToken(csrfToken)) {
        return NextResponse.json({ message: "Invalid CSRF submission." }, { status: 401, })
    }

    const id = session.user.id
    console.log(`Dumping payload: ${JSON.stringify(payload)}`);
    
    const activityId = payload.activityId
    await deleteActivity(id, activityId)

    return NextResponse.json({ activityId, message: "Success. Deleted participation." }, { status: 200, })
}

export async function POST(req: NextRequest, res: NextResponse) {
    const data = await req.json()
    const { csrfToken, payload } = data

    const session = await auth()
    if (!session || !session.user.email) {
        return NextResponse.json({ message: "401 Unauthorized" }, { status: 401, })
    }
    if (!verifyCsrfToken(csrfToken)) {
        return NextResponse.json({ message: "Invalid CSRF submission." }, { status: 401, })
    }
    const email = session.user.email

    const activity = await createActivity(email, payload)
    if (!activity!! || !activity.id) {
        return NextResponse.json({ message: "400 Could not add activity." }, { status: 400, })
    }

    const description = activity.custDescription??activity.cms_name
    const duration = activity.custMinutes??activity.runMinutes??"31"
    const mode = activity.custMode??'run'
    const body: Participation = {
        id: activity.id,
        dts: activity.runDTS,
        isStrava: 'false',
        description,
        mode,
        duration,
    }

    return NextResponse.json({ participation: body, message: "Success. Added participation." }, { status: 200, })
}