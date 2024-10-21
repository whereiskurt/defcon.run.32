'use server'

import { auth } from '@auth';
import dynamic from 'next/dynamic';
import { redirect } from 'next/navigation';
import { useMemo } from 'react';
import { strapi } from '../components/cms/data';
import { metadata } from '../layout';

export default async function Welcome() {
  const WelcomeBody = useMemo(() => dynamic(
    () => import('../components/cms/body'),
    {
      loading: () => <p></p>,
      ssr: false
    }
  ), [])

  const session = await auth()
  if (!session) redirect("/auth/signin")

  const raw = await strapi("/welcome")
  const body = raw.data.attributes.body

  return (
    <div>
      <WelcomeBody className={metadata.bodyClassName} body={body} />
    </div>
  )

}