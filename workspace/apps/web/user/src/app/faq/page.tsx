'use server'

import dynamic from 'next/dynamic';
import { useMemo } from 'react';
import { strapi } from '../components/cms/data';
import { metadata } from '../layout';

export default async function Welcome() {
  const FAQBody = useMemo(() => dynamic(() => import('../components/cms/body'), { ssr: true }), [])
  const FAQQuestions = useMemo(() => dynamic(() => import('../components/cms/faq/questions'), { ssr: true }), [])

  const raw = await strapi("/faq?populate=*")
  const body = raw.data.attributes.body
  const summary = raw.data.attributes.summary
  const questions = raw.data.attributes.FAQ
  
  const className=metadata.bodyClassName
  return (
    <div>
      <FAQBody className={className} body={body} />
      <FAQQuestions className={className} questions={questions} />
      <FAQBody className={className} body={summary} />
    </div>
  )

}