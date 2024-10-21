import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient } from '@aws-sdk/lib-dynamodb';
import { Entity, Table } from 'dynamodb-toolbox';

const accessKeyId: string = process.env["USER_DYNAMODB_ID"]!
const secretAccessKey: string = process.env["USER_DYNAMODB_SECRET"]!
const region: string = process.env["USER_DYNAMODB_REGION"]!
const endpoint: string = process.env["USER_DYNAMODB_ENDPOINT"]!

const DynamoClient = DynamoDBDocumentClient.from(
  new DynamoDBClient({
    ...(accessKeyId && secretAccessKey ? { credentials: { accessKeyId, secretAccessKey } } : {}),
    ...(region ? { region } : {}),
    ...(endpoint ? { endpoint } : {})
  }), {
  marshallOptions: {
    convertEmptyValues: false
  }
})

const UserTable = new Table({
  name: 'User',
  partitionKey: 'pk',
  sortKey: 'sk',
  DocumentClient: DynamoClient,
})

const ParticipationTable = new Table({
  name: 'Participation',
  partitionKey: 'pk',
  sortKey: 'sk',
  DocumentClient: DynamoClient,
})

export const ParticipationEntity = new Entity({
  name: 'Participation',
  attributes: {
    "human_id": { partitionKey: true },
    "sk": { sortKey: true },
    "sortKey": ["sk", 0],
    "activities": { type: 'list' },
    "connections": { type: 'map' },
    "badges": { type: 'map' },
    "stats": { type: 'map' },
    "stats_dt": { type: 'string' },
  },
  table: ParticipationTable
} as const)

export const UserEntity = new Entity({
  name: 'User',
  attributes: {
    "email": { partitionKey: true },
    "sk": { sortKey: true },
    "id": ["sk", 0],
    "eqr": { type: 'string' },
    "seed": { type: 'string' },
    "hash": { type: 'string' },
    "name": { type: 'string' },
    "rsapubSHA": { type: 'string' },
    "rsaprivSHA": { type: 'string' },
    "picture": { type: 'string' },
    "profile_theme": { type: 'string' },
    "profile_scope": { type: 'string' },
    "profile_waiver_signed": { type: 'boolean' },
    "profile_waiver_version": { type: 'string' },
    "profile_waiver_date": { type: 'string' },
    "github_profile": { type: 'map' },
    "discord_profile": { type: 'map' },
    "strava_profile": { type: 'map' },
    "strava_account": { type: 'map' },
  },
  table: UserTable
} as const)

export function EntityMapper() {
  const EntityMap = {
    "User": UserEntity,
    "Participation": ParticipationEntity
  }
  return EntityMap
}

export interface ManualActivity {
  id?: string;
  type: string;
  cms_id?: string;
  cms_name?: string;
  runDTS: string;
  runMinutes?: string;
  custDescription?: string;
  custMode?: string;
  custUnit?: string;
  custDistance?: string;
  custMinutes?: string;
}

export interface Participation {
  id: string;
  description: any;
  dts: string;
  duration: string;
  mode: string;
  isStrava: string;
}