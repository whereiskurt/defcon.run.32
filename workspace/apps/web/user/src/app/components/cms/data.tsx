'use server';
export async function strapi(url: string) {
  const res = await fetch(`${process.env.STRAPI_URL}/api${url}`, {
    method: 'GET',
    headers: {
      'Authorization': `bearer ${process.env.AUTH_STRAPI_TOKEN}`
    },
    next: { revalidate: 30 }
  });

  if (!res.ok) {
    throw new Error('Network response was not ok');
  }
  const data = await res.json();
  return data;
}
