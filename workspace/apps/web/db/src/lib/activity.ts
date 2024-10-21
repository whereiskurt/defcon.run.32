import { EntityMapper, ManualActivity, Participation } from "./db";
import { v4 as uuidv4 } from 'uuid';

const SAFE_MAX_ACTIVITIES = 24;

export async function getActivities(email: string) {
  //TODO: Untrusted Data - Check email and activity
  const e = EntityMapper()
  const u = await e.User.query(email)
  if (!u.Items || u.Items.length === 0) {
    console.log(`ERROR: Expected to find ${email} user record by did not.`);
    console.log(`SECURITY: This means the auth'd user's email doesn't exist..? Enummerating somehow?`);
    return
  }
  const user = u.Items[0]
  let p = await e.Participation.query(user.id)
  if (!p.Items || p.Items.length === 0) {
    return
  }

  const res: Participation[] = []

  const participation = p.Items[0];
  participation.activities?.forEach(activity => {
    if (activity.type === "cms") {
      res.push({
        id: activity.id,
        description: activity.cms_name,
        dts: activity.runDTS,
        duration: activity.runMinutes,
        mode: activity.runMode ?? "run",
        isStrava: 'false'
      })
    } else if (activity.type === "custom") {
      res.push({
        id: activity.id,
        description: activity.custDescription,
        dts: activity.runDTS,
        duration: activity.custMinutes,
        mode: activity.custMode,
        isStrava: 'false'
      })
    } else if (activity.type === "strava") {
      res.push({
        id: activity.id,
        description: activity.name,
        dts: activity.start_date,
        duration: activity.elapsed_time,
        mode: activity.sport_type,
        isStrava: 'true'
      })
    }
  })
  return res
}
export async function createActivity(email: string, activity: ManualActivity) {
  const e = EntityMapper()
  const u = await e.User.query(email)
  if (!u.Items || u.Items.length === 0) {
    console.log(`ERROR: Expected to find ${email} user record by did not.`);
    console.log(`SECURITY: This means the auth'd user's email doesn't exist..? Enummerating somehow?`);
    return
  }
  const user = u.Items[0]
  let p = await e.Participation.query(user.id)
  if (!p.Items || p.Items.length === 0) {
    await e.Participation.put({ human_id: user.id, sortKey: "DC32" })
    p = await e.Participation.query(user.id)
    if (!p.Items || p.Items.length === 0) {
      console.log(`ERROR: Failed to create new participation record for ${email}.`);
      console.log(`SECURITY: DynamoDB out of writes? Index collision?`);
      return
    }
  }
  const participation = p.Items[0];
  activity.id = uuidv4()
  if (!participation.activities!!) {
    participation.activities = [activity]
  } else {
    if (participation.activities.length > SAFE_MAX_ACTIVITIES) {
      console.log(`ERROR: Maximum ${SAFE_MAX_ACTIVITIES} participations allowed for  ${email}`);
      console.log(`SECURITY: Unreasonable amount of participations.`);
      return
    }
    participation.activities.push(activity)
  }
  await e.Participation.update(participation)

  return activity
}
export async function deleteActivity(userId: string, activityId: string) {
  const e = EntityMapper()

  let p = await e.Participation.query(userId)
  if (!p.Items || p.Items.length === 0) {
    return
  }

  if (!p.Items[0].activities || p.Items[0].activities.length === 0) {
    return
  }

  const a = p.Items[0].activities
  const newAct = a.filter(activity => activity.id !== activityId);

  p.Items[0].activities = newAct
  await e.Participation.update(p.Items[0])

  return
}