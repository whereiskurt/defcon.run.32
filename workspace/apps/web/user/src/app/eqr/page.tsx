import { auth } from "@auth";
import { metadata } from "../layout";
import { redirect } from "next/navigation";
import { FaQrcode } from "react-icons/fa";

export default async function Index({ searchParams }: {
  searchParams: { [key: string]: string | string[] | undefined }
}) {
  const className = metadata.bodyClassName
  const session = await auth()
  if (!session) redirect("/auth/signin")
  return (
    <div className={className}>
      <h1 className="text-4xl font-bold mb-4"><FaQrcode />EQR</h1>
      <p className="text-xl">
        Show the dashboard and the increased social connections.
        {searchParams.h}
      </p>
    </div>
  );
}
