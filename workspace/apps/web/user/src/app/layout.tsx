import './components/global.css';
import Header from "@components/header"
import Footer from "@components/footer"
import { auth } from "@auth"
import { SessionProvider } from 'next-auth/react';
import { NextUIProvider } from '@nextui-org/react';

export const metadata = {
  title: 'DEFCON.run',
  description: 'Community website for DEFCON.run members.',
  bodyClassName: 'mx-auto max-w-[900px] p-2'
};

export default async function RootLayout({ children }: { children: React.ReactNode }) {
  const session = await auth()
  const theme = session?.user?.theme ?? "dark"
  return (
    <SessionProvider session={session}>
      <html lang="en" className={theme}>
        <body>
          <Header session={session} />
          <NextUIProvider >
            {children}
          </NextUIProvider>
          <Footer />
        </body>
      </html>
    </SessionProvider>
  );
}