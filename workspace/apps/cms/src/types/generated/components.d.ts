import type { Schema, Attribute } from '@strapi/strapi';

export interface ParticipationActivity extends Schema.Component {
  collectionName: 'components_participation_activities';
  info: {
    displayName: 'Stage';
    icon: 'walk';
    description: '';
  };
  attributes: {
    name: Attribute.String;
    description: Attribute.Text;
    duration: Attribute.Component<'participation.duration'>;
    gpxs: Attribute.Media;
    images: Attribute.Media & Attribute.Required;
    activity_type: Attribute.Enumeration<['run', 'walk', 'ruck']> &
      Attribute.Required &
      Attribute.DefaultTo<'run'>;
    distance: Attribute.Component<'participation.distance'>;
    start_location: Attribute.Component<'participation.location'>;
    end_location: Attribute.Component<'participation.location'>;
  };
}

export interface ParticipationDistance extends Schema.Component {
  collectionName: 'components_participation_distances';
  info: {
    displayName: 'Distance';
    icon: 'earth';
    description: '';
  };
  attributes: {
    distance: Attribute.Decimal;
    unit: Attribute.Enumeration<['km', 'mi', 'steps', 'track laps']>;
  };
}

export interface ParticipationDuration extends Schema.Component {
  collectionName: 'components_participation_durations';
  info: {
    displayName: 'Duration';
  };
  attributes: {
    days: Attribute.Integer;
    hours: Attribute.Integer;
    minutes: Attribute.Integer &
      Attribute.SetMinMax<
        {
          min: 0;
          max: 59;
        },
        number
      > &
      Attribute.DefaultTo<0>;
  };
}

export interface ParticipationFaq extends Schema.Component {
  collectionName: 'components_participation_faqs';
  info: {
    displayName: 'FAQ';
    description: '';
  };
  attributes: {
    question: Attribute.Blocks & Attribute.Required;
    answer: Attribute.Blocks & Attribute.Required;
    last_change: Attribute.DateTime & Attribute.Required;
  };
}

export interface ParticipationLocation extends Schema.Component {
  collectionName: 'components_participation_locations';
  info: {
    displayName: 'Location';
    icon: 'pin';
    description: '';
  };
  attributes: {
    latitude: Attribute.Float &
      Attribute.Required &
      Attribute.SetMinMax<
        {
          min: -90;
          max: 90;
        },
        number
      >;
    longitude: Attribute.Float &
      Attribute.Required &
      Attribute.SetMinMax<
        {
          min: -180;
          max: 360;
        },
        number
      >;
    images: Attribute.Media;
    svgPin: Attribute.Text;
  };
}

export interface SponsorshipSponsor extends Schema.Component {
  collectionName: 'components_sponsorship_sponsors';
  info: {
    displayName: 'Sponsor';
    icon: 'handHeart';
    description: '';
  };
  attributes: {
    name: Attribute.String;
    logo: Attribute.Media & Attribute.Required;
    url: Attribute.String & Attribute.Required;
    body: Attribute.Blocks & Attribute.Required;
  };
}

declare module '@strapi/types' {
  export module Shared {
    export interface Components {
      'participation.activity': ParticipationActivity;
      'participation.distance': ParticipationDistance;
      'participation.duration': ParticipationDuration;
      'participation.faq': ParticipationFaq;
      'participation.location': ParticipationLocation;
      'sponsorship.sponsor': SponsorshipSponsor;
    }
  }
}
