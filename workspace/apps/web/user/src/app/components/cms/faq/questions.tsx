'use client';

import { Accordion, AccordionItem } from '@nextui-org/react';
import dynamic from 'next/dynamic';
import { useMemo } from 'react';

interface FAQProps {
  questions: any
  className?: string;
}

export default function FAQ({ questions, className="" }: FAQProps) {
  const Body = useMemo(() => dynamic(() => import('../body'), {
    loading: () => <p></p>,
    ssr: true
  }), [])

  const itemClasses = {
    base: "p-0",
    title: "p-0 text-current",
    subtitle: "p-0",
    // trigger: "px-2 py-0 data-[hover=true]:bg-default-100 rounded-lg h-14 flex items-center",
    indicator: "text-2xl",
    content: "text-xl ",
  };

  const tsxItems = questions.map((item: any) => (
    <AccordionItem 
      title={<Body body={item.question} />} 
      subtitle={"Updated: " + item.last_change.substring(0,10)}
      textValue={`Accordion ${item.id}`}
      >
      <Body body={item.answer} />
    </AccordionItem>
  ));

  return (
    <Accordion className={className} selectionMode='multiple' variant='bordered' isCompact itemClasses={itemClasses}>
      {tsxItems}
    </Accordion>
  );
}