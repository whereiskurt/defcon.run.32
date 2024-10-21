'use server'

import { auth } from '@auth';
import { getActivities, Participation as ParticipationType } from '@defcon.run/web/db';
import dynamic from 'next/dynamic';
import { redirect } from 'next/navigation';
import { useMemo } from 'react';
import { FaStrava } from 'react-icons/fa';
import { strapi } from '../components/cms/data';
import { RunSelect } from '../components/participation/manual';
import { metadata } from '../layout';

const classActivity = "flex"
const runWithStrava = <div className={classActivity}>(<FaStrava color="red" size={"20px"} /> Run)</div>
const walkWithStrava = <div className={classActivity}>(<FaStrava color="red" size={"20px"} /> Walk)</div>
const walk = <div className={classActivity}>(Walk)</div>
const ruck = <div className={classActivity}>(Ruck)</div>

export interface RouteData {
  "data": [
    {
      "id": string,
      "attributes" : {
        name: string,
        mode: string,
        distance: string,
      }
    }
  ]
}

export default async function Participation({ params, searchParams, }: {
  params: { slug: string }
  searchParams: { [key: string]: string | string[] | undefined }
}) {
  //These have to be the FIRST lines or tsc error.
  const ParticipateBody = useMemo(() => dynamic(() => import('../components/cms/body'), { ssr: true }), [])
  const ParticipateTab = useMemo(() => dynamic(() => import('../components/participation/tab'), { ssr: true }), [])

  const pdata: ParticipationType[] = []
  const runSelect: RunSelect[] = [];

  const session = await auth()
  if (!session || !session.user.email) redirect("/auth/signin")
  const className = metadata.bodyClassName

  const contentBody = await strapi("/participation?populate=*")
  const intro = contentBody.data.attributes.intro

  const routes: RouteData = await strapi("/routes")

  routes.data.forEach(({ id, attributes }) => {
    if (!attributes.mode!!) { return }
    runSelect.push({
      key: `${id},${attributes.name}`,
      label: attributes.name,
    })
  });

  const r = await getActivities(session.user.email)
  if (r!! && r.length > 0) {
    pdata.push(... r)
  }

  return (
    <div>
      <ParticipateBody body={intro} className={className} />
      <ParticipateTab participations={pdata} runSelect={runSelect} session={session} searchParams={searchParams} className={className} />
    </div>
  )

}