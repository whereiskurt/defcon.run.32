import { Navbar, NavbarContent, NavbarItem } from '@nextui-org/react';
import Link from 'next/link';

import { FaMastodon, FaMusic, FaStrava, FaTwitter, FaYoutube, FaYoutubeSquare } from 'react-icons/fa';
import { FaSignalMessenger } from "react-icons/fa6";
import MenuDropDown from '../header/dropdown-menu';

// eslint-disable-next-line @typescript-eslint/no-empty-interface
export interface FooterProps { }

export function Footer(props: FooterProps) {
  return (
    <div>
      <Navbar className="mt-2" maxWidth='full'>
        <NavbarContent className="" justify="start">
          <NavbarItem >
          </NavbarItem>
        </NavbarContent>
        <NavbarContent className="" justify="center">
          <NavbarItem>
            <a className="text-gray-600 hover:text-gray-400 cursor-pointer"
              target='_blank' href='https://www.strava.com/clubs/1071823/'>
              <FaStrava size={"2em"} />
            </a>
          </NavbarItem>
          <NavbarItem>
            <a className="text-gray-600 hover:text-gray-400 cursor-pointer height:auto width:auto"
              target='_blank' href='https://defcon.social/@run'>
              <FaMastodon size={"2em"} />
            </a>
          </NavbarItem>
          <NavbarItem>
            <a className="text-gray-600 hover:text-gray-400 cursor-pointer"
              target='_blank' href='https://x.com/defcon_run'>
              <FaTwitter size={"2em"} />
            </a>
          </NavbarItem>
          <NavbarItem>
            <a className="text-gray-600 hover:text-gray-400 cursor-pointer"
              target='_blank' href='https://signal.org/download/'>
              <FaSignalMessenger size={"2em"} />
            </a>
          </NavbarItem>
          <NavbarItem>
            <a className="text-gray-600 hover:text-gray-400 cursor-pointer"
              target='_blank' href='https://music.youtube.com/playlist?list=PLKAXqaYUV3cqenJ9edbeAQTA25CoKgdg4'>
              <FaYoutube size={"2em"} />
            </a>
          </NavbarItem>
        </NavbarContent>
        <NavbarContent className="" justify="end">
          <NavbarItem >
          </NavbarItem>
        </NavbarContent>

      </Navbar>
    </div>
  );
}

export default Footer;
