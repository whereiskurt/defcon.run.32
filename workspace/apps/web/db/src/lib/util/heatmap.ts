import { UserEntity } from "../db";
import { DC32_UNIX_END, DC32_UNIX_START, fetchActivities, StravaActivity, updateStravaToken } from "../strava";


// function sleep(ms: number) {
//   return new Promise(resolve => setTimeout(resolve, ms));
// }

export async function ProcessHeatMap(unixNow: number = Math.floor(Date.now() / 1000), beforeUnix: number = DC32_UNIX_END, afterUnix: number = DC32_UNIX_START) {
  try {
    const users = await UserEntity.scan();
    // let c = 0;
    for (const user of users.Items || []) {
      const { email } = user;

      let strava_account = user['strava_account'];
      if (!strava_account) continue;

      if (!(email === 'whereiskurt@gmail.com')) continue;

      strava_account = await updateStravaToken({ email, strava_account, unixNow });
      // c++;
      // if (c > 5) break;
      // await sleep(3000);

      const resp = await fetchActivities({ strava_account, beforeUnix, afterUnix });
      if (resp['error']) {
        console.error(`Couldn't fetch activities for ${email} - ${resp['error']}`)
        continue
      }
      const activities = resp['data'] as StravaActivity[]
      console.log(`${JSON.stringify(activities)}`);

    }
  } catch (error) {
    console.error(`Failed to Scan Users: ${error}`);
  }
}

ProcessHeatMap()