import { Strapi } from '@strapi/strapi';
export default (config: any, { strapi }: { strapi: Strapi }) => {
  return async (ctx: { remove: (header: string) => void; }, next: () => any) => {
    await next();
    //Pulling this one makes our Strapi incognito. :) 
    //We only use REST APIs from the application server
    ctx.remove('X-Powered-By');
    ctx.remove('Content-Security-Policy');
  };
};
