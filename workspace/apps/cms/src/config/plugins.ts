module.exports = ({ env }) => ({
  upload: {
    config: {
      provider: 'aws-s3',
      providerOptions: {
        baseUrl: env('AWS_CDN_URL'),
        rootPath: "",
        s3Options: {
          credentials: {
            accessKeyId: env('AWS_ACCESS_KEY_ID'),
            secretAccessKey: env('AWS_ACCESS_SECRET'),
          },
          region: env('AWS_REGION'),
          params: {
            ACL: null,
            signedUrlExpires: env('AWS_SIGNED_URL_EXPIRES', 15 * 60),
            Bucket: env('AWS_BUCKET'),
          },
        },
      },
      actionOptions: {
        upload: {},
        uploadStream: {},
        delete: {},
      },
    },
    // config: {
    //   provider: 'local',
    //   sizeLimit: 2500000, //2.5MB
    // }
  },
  email: {
    config: {
      provider: 'amazon-ses',
      providerOptions: {
        key: env('AWS_SES_KEY'),
        secret: env('AWS_SES_SECRET'),
        amazon: env('AWS_SES_SERVER'),
      },
      settings: {
        defaultFrom: 'strapi@support.defcon.run',
        defaultReplyTo: 'strapi@support.defcon.run',
      },
    },
  },
  'publisher': {
    enabled: true,
    config: {
      hooks: {
        beforePublish: async ({ strapi, uid, entity }) => {
          console.log('beforePublish');
        },
        afterPublish: async ({ strapi, uid, entity }) => {
          console.log('afterPublish');
        },
        beforeUnpublish: async ({ strapi, uid, entity }) => {
          console.log('beforeUnpublish');
        },
        afterUnpublish: async ({ strapi, uid, entity }) => {
          console.log('afterUnpublish');
        },
      },
    },
  },
});