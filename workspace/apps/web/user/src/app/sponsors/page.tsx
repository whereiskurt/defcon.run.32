'use server'

import dynamic from 'next/dynamic';
import { useMemo } from 'react';
import { strapi } from '../components/cms/data';
import { metadata } from '../layout';

export default async function Sponsors() {
  const SponsorsBody = useMemo(
    () => dynamic(() => import('../components/cms/body'), {
      loading: () => <p></p>,
      ssr: true
    }), [])

  const raw = await strapi("/sponsor?populate[0]=sponsors&populate[1]=sponsors.logo")
  const intro = raw.data.attributes.intro
  const summary = raw.data.attributes.summary
  const className=metadata.bodyClassName
  return (
    <div>
      <SponsorsBody className={className} body={intro} />
      <SponsorsBody className={className} body={summary} />
    </div>
  )

}