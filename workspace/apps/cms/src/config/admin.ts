export default ({ env }) => ({
  auth: {
    secret: env('ADMIN_JWT_SECRET'),
  },
  apiToken: {
    salt: env('API_TOKEN_SALT'),
  },
  transfer: {
    token: {
      salt: env('TRANSFER_TOKEN_SALT'),
    },
  },
  flags: {
    nps: false,
    promoteEE: false,
  },
  // url: "/rabbit_admin",
});

// - ADMIN_PATH
// - STRAPI_ADMIN_BACKEND_URL