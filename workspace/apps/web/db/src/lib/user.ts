import { createHash, generateKeyPairSync } from 'crypto';
import * as qr from 'qrcode';
import { EntityMapper } from './db';
import { v4 as uuidv4 } from 'uuid';

export async function createUser(email: string) {
  const e = EntityMapper()
  const u = await e.User.query(email)
  if (!u.Items || u.Items.length === 0) {
    const { publicKey, privateKey } = generateKeyPairSync('rsa', {
      modulusLength: 2048,
    });

    const id = uuidv4()
    const seed = uuidv4()
    const rsapub = publicKey.export({ type: 'spki', format: 'pem' }).toString('base64');
    const rsapriv = privateKey.export({ type: 'pkcs8', format: 'pem' }).toString('base64');
    const rsapubSHA = createHash('sha256').update(`${rsapub}`).digest('hex');
    const rsaprivSHA = createHash('sha256').update(`${rsapriv}`).digest('hex');
    const hash = createHash('sha256').update(`${rsapubSHA}${seed}`).digest('hex');
    const eqr = await qr.toDataURL(`https://app.defcon.run/e?h=${hash}`, { errorCorrectionLevel: 'H', width: 300 });
    const profile_theme = "dark";

    const newUser = {
      email: email,
      id,
      pk: email,
      eqr,
      hash,
      seed,
      rsapubSHA,
      rsaprivSHA,
      profile_theme
    }
    e.User.put(newUser)
    return { e, newUser }
  }

  const user = u.Items.at(0)
  return { e, user }
}

export async function getUser(email: string) {
  const e = EntityMapper()
  const u = await e.User.query(email)
  if (!u.Items || u.Items.length === 0) {
    return
  }
  const user = u.Items[0];
  return user
}