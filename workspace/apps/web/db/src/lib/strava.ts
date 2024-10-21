import { EntityMapper, UserEntity } from "./db";
import { getUser } from "./user";

export const DC32_UNIX_START = Math.floor(new Date("Aug 8 2024 00:00:00 GMT-0700 (Pacific Daylight Time)").getTime() / 1000);
export const DC32_UNIX_END = Math.floor(new Date("Aug 12 2024 00:00:00 GMT-0700 (Pacific Daylight Time)").getTime() / 1000);
const fmtAsWeeksDaysHours = (seconds: number): string => `${Math.floor(seconds / 604800) ? `${Math.floor(seconds / 604800)}wks` : ''}${Math.floor((seconds % 604800) / 86400) ? `${Math.floor((seconds % 604800) / 86400)}days` : ''}${Math.floor((seconds % 86400) / 3600)}hrs${Math.floor((seconds % 3600) / 60)}min${seconds % 60}seconds`;

export interface StravaActivity {
  resource_state?: number;
  athlete?: {
    id?: number;
    resource_state?: number;
  };
  name?: string;
  distance?: number;
  moving_time?: number;
  elapsed_time?: number;
  total_elevation_gain?: number;
  type?: string;
  sport_type?: string;
  workout_type?: number | null;
  id?: number;
  start_date?: string;
  start_date_local?: string;
  timezone?: string;
  utc_offset?: number;
  location_city?: string | null;
  location_state?: string | null;
  location_country?: string | null;
  achievement_count?: number;
  kudos_count?: number;
  comment_count?: number;
  athlete_count?: number;
  photo_count?: number;
  map?: {
    id?: string;
    summary_polyline?: string;
    resource_state?: number;
  };
  trainer?: boolean;
  commute?: boolean;
  manual?: boolean;
  private?: boolean;
  visibility?: string;
  flagged?: boolean;
  gear_id?: string;
  start_latlng?: [number, number] | [];
  end_latlng?: [number, number] | [];
  average_speed?: number;
  max_speed?: number;
  average_cadence?: number;
  average_temp?: number;
  has_heartrate?: boolean;
  average_heartrate?: number;
  max_heartrate?: number;
  heartrate_opt_out?: boolean;
  display_hide_heartrate_option?: boolean;
  elev_high?: number;
  elev_low?: number;
  upload_id?: number;
  upload_id_str?: string;
  external_id?: string;
  from_accepted_tag?: boolean;
  pr_count?: number;
  total_photo_count?: number;
  has_kudoed?: boolean;
}

export async function updateStravaToken({ email, strava_account, unixNow }: { email: string; strava_account: any; unixNow: number; }) {
  const clientId = process.env['AUTH_STRAVA_CLIENT_ID'] ?? process.env['STRAVA_CLIENT_ID'] as string
  const clientSecret = process.env['AUTH_STRAVA_CLIENT_SECRET'] ?? process.env['STRAVA_CLIENT_SECRET'] as string

  if (!strava_account) {
    console.log(`Not a Strava connected user.`);
    return
  } else if (!(clientId || clientSecret)) {
    console.error(`ERROR: No Strava OAuth credentials - missing client id+secret`);
    console.error(`ERROR: check the followin ENV vars: AUTH_STRAVA_CLIENT_ID, AUTH_STRAVA_CLIENT_SECRET`);
    return
  }

  const expiredSecs = unixNow - Number(strava_account.expires_at);
  if (expiredSecs <= 0) { //Not expired yet!
    console.log(`INFO: ${email} still valid for ${fmtAsWeeksDaysHours(expiredSecs)}`);
    return strava_account;
  }

  const resp = await fetchRefresh({ refresh_token: strava_account.refresh_token, clientId, clientSecret })
  if (resp['error']) {
    console.error(`Could not get Refresh Token: ${resp['error']}`);
    return
  }

  const updatedStravaAccount = {
    ...strava_account,
    access_token: resp.data.access_token,
    refresh_token: resp.data.refresh_token,
    expires_at: resp.data.expires_at,
    expires_in: resp.data.expires_in,
  };

  const ent = EntityMapper()
  const user = await getUser(email)

  await ent.User.update({
    email,
    id: user?.id,
    sk: user?.sk,
    "strava_account": updatedStravaAccount,
  });

  console.log(`INFO: ${email} retrieved new API token from Strava`);

  return updatedStravaAccount
}

export async function fetchActivities({ strava_account, beforeUnix, afterUnix }: { strava_account: any; beforeUnix: number; afterUnix: number; }): Promise<{ data: any; error?: undefined; } | { error: unknown; data?: undefined; }> {
  try {
    const bearer = strava_account.access_token
    if (!bearer) {
      throw new Error(`ERROR: No access_token in strava_account`);
    }

    const response = await fetch(`https://www.strava.com/api/v3/athlete/activities?before=${beforeUnix}&after=${afterUnix}&page=1&per_page=30`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${bearer}`,
      },
    });
    if (!response.ok) {
      throw new Error(`${response.status}`);
    }
    const data = await response.json();
    return { data };

  } catch (error) {
    console.error(`Error refreshing Strava token: ${error}`);
    return { error };
  }

}

async function fetchRefresh({ refresh_token, clientId, clientSecret }: { refresh_token: string; clientId: string; clientSecret: string; }) {
  try {
    const response = await fetch('https://www.strava.com/api/v3/oauth/token', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        client_id: clientId,
        client_secret: clientSecret,
        grant_type: 'refresh_token',
        refresh_token: refresh_token,
      }),
    });

    if (!response.ok) {
      throw new Error(`${response.status}`);
    }

    const data = await response.json();
    return { data };
  } catch (error) {
    console.error(`Error refreshing Strava token: ${error}`);
    return { error };
  }
}
