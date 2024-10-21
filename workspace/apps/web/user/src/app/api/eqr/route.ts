import { auth } from '@auth';
import { getUser } from '@defcon.run/web/db';
import { NextRequest, NextResponse } from 'next/server';
import { verifyCsrfToken } from '../util';

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

    const user = await getUser(session.user.email)

    
    return NextResponse.json({ message: "Success. Added participation.", user }, { status: 200, })
}