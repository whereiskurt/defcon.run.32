# DEFCON.run
Hello World! I present to you: the full Infastructure as Code and Front-end repository for the https://app.defcon.run site for DefCon 32 2024.

For last many years defcon.run has been evolving as the annual premiere hacker community running event. It has gone from loose associations to a formalized on the books event. Along the way we've been trying many new things - including this site/app.

# What am I looking at?
This is a release of a modern full-stack webapp built using terraform+Nx+Next.js+Next-UI+Auth.js+Strapi. I have a long history of writing code - and this is kind of an amalgamation of my techniques and approach.

I used terraform to standup the AWS infrastructure for the site. The only exception is the AWS SES setup which I did manually/clickops. Otherwise, it's a 'tf apply' and 'tf destroy' to bring all the certs, lbs and cluster up/down. Early on I would destroy the infra everyday and bring it back to work on.

I used Nx as my build system - it's an awesome way to manage a mono-repo like this one.

We deploy a pre-built Strapi application to our ECS as Docker image. Our Next.js application, also a Docker image, makes calls to Strapi to get the site content. Local development is super easy - it's just running a Strapi image locally and pointing the locally running Next.js to that. I also run a DynamoDB in a Docker image for local dev.

### AWS Architecture
![Service Layout - https___defcon run - AWS Resources](https://github.com/user-attachments/assets/20b5ba88-f4e4-446e-b165-594bfb5f38a9)

### Modern Responsive Design w/ Ligh+Dark+Custom Theming
We used Next.js, Next-UI and Auth.js (ie. NextAuth.js) for a modern look and feel:
![defcon run responsive design](https://github.com/user-attachments/assets/8576a751-df48-4e7c-8a63-3c5db915dd2f)

### Strapi CMS
We used a headless Strapi CMS implementation to store static and homesite related data.
<img width="1145" alt="Screenshot 2024-10-22 at 20 38 00" src="https://github.com/user-attachments/assets/abf5c2ad-2e33-411d-9fde-463c00e6e3f6">
