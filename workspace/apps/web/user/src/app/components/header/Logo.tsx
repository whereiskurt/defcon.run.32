import React from "react";
import BunnyWhite from "@defcon.run/web/public/Buny-White-Trans.svg"
import BunnyBlack from "@defcon.run/web/public/Bunny-Black-Trans.svg"

import Link from 'next/link'
import Image from 'next/image'

export function Logo(params: any) {
  const session = params.session
  const theme = session?.user?.theme??"dark"
  return (
    <Link color="foreground" href="/">
      <Image alt="Bunny" priority={true} 
        width={200} src={theme !== "light" ? BunnyWhite : BunnyBlack} />
    </Link>)
};
