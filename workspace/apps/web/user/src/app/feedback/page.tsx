'use server'

import dynamic from 'next/dynamic';
import { useMemo } from 'react';
import { strapi } from '../components/cms/data';
import { metadata } from '../layout';

export default async function FeedbackPage() {
  const SponsorsBody = useMemo(
    () => dynamic(() => import('../components/cms/body'), {
      loading: () => <p></p>,
      ssr: true
    }), [])

  const raw = await strapi("/feedback")
  const intro = raw.data.attributes.body
  const className = metadata.bodyClassName
  return (
    <div>
      <SponsorsBody className={className} body={intro} />
    </div>
  )

}