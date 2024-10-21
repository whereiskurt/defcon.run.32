import { auth } from "@auth";
import dynamic from "next/dynamic";
import { redirect } from 'next/navigation';
import { useMemo } from "react";
import { strapi } from '../components/cms/data';

export default async function Page() {
  const Map = useMemo(() => dynamic(() => import('../components/map/basic'), {
    loading: () => <p>A map is loading</p>,
    ssr: false
  }
  ), [])

  const session = await auth()
  if (!session) redirect("/auth/signin")

  const routes = await strapi("/routes?populate=*")

  return (
    <div className={"mx-auto w-[98%] p-2"}>
      <Map raw={JSON.stringify(routes.data)} center={[36.1320813, -115.1667648]} />
    </div>
  );
} 