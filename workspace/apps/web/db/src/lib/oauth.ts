import { createUser } from "./user";

export async function UpdateStrava(email: string, strava_profile: any, strava_account: any) {
  const { e: ent, user } = await createUser(email);
  await ent.User.update({
    email,
    id: user?.id,
    sk: user?.sk,
    name: user?.name ?? strava_profile.username,
    picture: user?.picture ?? strava_profile.profile_medium,
    "strava_profile": strava_profile,
    "strava_account": strava_account,
  });
}

export async function UpdateDiscord(email: string, discord_profile: any) {
  const { e: ent, user } = await createUser(email);
  await ent.User.update({
    email,
    id: user?.id,
    sk: user?.sk,
    name: user?.name ?? discord_profile.global_name,
    picture: user?.picture ?? discord_profile.image_url,
    "discord_profile": discord_profile,
  });
}

export async function UpdateGithub(email: string, github_profile: any) {
  const { e: ent, user } = await createUser(email);
  await ent.User.update({
    email: user?.email,
    sk: user?.sk,
    name: user?.name ?? github_profile.name,
    picture: user?.picture ?? github_profile.avatar_url,
    "github_profile": github_profile,
  });
}

export async function UpdateNodeMailer(email: string) {
  await createUser(email);
}
