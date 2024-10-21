'use server'

import { auth } from '@auth';
import { redirect } from 'next/navigation';
import dynamic from 'next/dynamic';
import { useMemo } from 'react';
import { strapi } from './components/cms/data';
import { BlocksContent } from '@strapi/blocks-react-renderer';
import { metadata } from './layout';

export default async function Welcome() {
  const HypeBody = useMemo(() => dynamic(
    () => import('./components/cms/body'),
    {
      loading: () => <p></p>,
      ssr: true
    }
  ), [])

  const session = await auth()
  if (session) redirect("/welcome")

  const raw = await strapi("/hype")
  const body = raw.data.attributes.body

  return (
    <div className={metadata.bodyClassName}>
      <HypeBody body={body} />
    </div>
  )

}