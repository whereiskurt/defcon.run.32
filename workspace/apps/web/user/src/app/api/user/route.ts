import { auth } from '@auth';
import { getUser } from '@defcon.run/web/db';
import { NextRequest, NextResponse } from 'next/server';

export async function GET(req: NextRequest, res: NextResponse) {
    const session = await auth()
    if (!session || !session.user.email) {
        return NextResponse.json({ message: "401 Unauthorized" }, { status: 401, })
    }
    const user = await getUser(session.user.email)
    return NextResponse.json({ message: "Success. Added participation.", user }, { status: 200, })
}