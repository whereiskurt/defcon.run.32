import { Accordion, AccordionItem, Button, DatePicker, Divider, Input, Radio, RadioGroup, Select, SelectItem } from '@nextui-org/react';
import { useEffect, useState } from 'react';

import { ManualActivity, Participation } from '@defcon.run/web/db';
import { parseAbsoluteToLocal, parseDate } from "@internationalized/date";
import { getCsrfToken } from 'next-auth/react';
import { FaPlusCircle } from 'react-icons/fa';

export interface RunSelect {
  key: string;
  label: string;
}

interface ManualEntryFormProps {
  participations: Participation[];
  setPData: any
  setShowTabKey: any
  runSelect: RunSelect[]
}

const ManualFormComponent: React.FC<ManualEntryFormProps> = ({ runSelect, setPData, participations, setShowTabKey }) => {

  const [custMode, setCustMode] = useState<string>('');
  const [custDate, setCustDate] = useState(parseAbsoluteToLocal("2024-08-08T13:00:00Z"));
  const [custDesc, setCustDesc] = useState<string>('');
  const [custMinutes, setCustMinutes] = useState<string>('30');
  const [runMinutes, setRunMinutes] = useState<string>('30');
  const [custDist, setCustDist] = useState<string>('5');
  const [custUnit, setCustUnit] = useState<string>('km');
  const [selectedRun, setSelectRun] = useState<string>('');
  const [csrfToken, setCsrfToken] = useState<string | null>(null)

  const [error, setError] = useState<string | null>(null)
  const [pending, setPending] = useState<boolean>(true)

  useEffect(() => {
    const fetchCsrfToken = async () => {
      const token = await getCsrfToken()
      setCsrfToken(token)
    }
    fetchCsrfToken();
    setPending(false)
  }, [])

  const handleFormSubmit = async (event: React.FormEvent) => {
    event.preventDefault();

    const key = `${Array.from(selectedRun)[0]}`;
    const id = key.split(",", 2)[0];
    const label = key.split(",", 2)[1];

    const runLoad: ManualActivity = {
      type: 'cms',
      runDTS: `${custDate}`,
      cms_id: id,
      cms_name: label,
      runMinutes: runMinutes
    }

    const customLoad: ManualActivity = {
      type: 'custom',
      custMode: custMode,
      custDescription: custDesc,
      custUnit: custUnit,
      custDistance: custDist,
      custMinutes: custMinutes,
      runDTS: `${custDate}`,
    }
    let payload = runLoad
    if (custDesc !== "") {
      payload = customLoad
    }

    try {
      const res = await fetch("/api/participation", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ csrfToken, payload: payload }),
      })

      if (!res.ok || res.status != 200) {
        const errorData = await res.json()
        throw new Error(errorData.error)
      } else {
        const record = await res.json()
        const part: Participation = record.participation
        participations.unshift(part)
        setPData(participations)
        setShowTabKey("history");
      }
    } catch (error: any) {
      console.log(`Error ${JSON.stringify(error)}`);
    }

  };

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    // Allow: Backspace, Delete, Tab, Escape, Enter, Arrow keys
    if (
      e.key === 'Backspace' ||
      e.key === 'Delete' ||
      e.key === 'Tab' ||
      e.key === 'Escape' ||
      e.key === 'Enter' ||
      e.key === 'ArrowLeft' ||
      e.key === 'ArrowRight' ||
      e.key === 'ArrowUp' ||
      e.key === 'ArrowDown' ||
      e.key === '.'
    ) {
      return;
    }
    // Prevent: any non-numeric key
    if (!/^0|[1-9]\d*(\.\d+)?$/.test(e.key)) {
      e.preventDefault();
    }
  };

  return (
    <form onSubmit={handleFormSubmit} className="p-4 space-y-4">
      <div className='flex flex-col space-y-4 md:flex-row md:space-x-4 md:space-y-0'>
        <DatePicker
          variant="bordered"
          label="Activity Date"
          isRequired={true}
          value={custDate}
          onChange={setCustDate}
          // minValue={parseDate("2024-08-08")}
          // maxValue={parseAbsoluteToLocal("2024-08-11T23:59:59Z")}
          hideTimeZone
          showMonthAndYearPickers
        />

        <Select
          label="Activity"
          variant="bordered"
          placeholder="Select defcon.run route..."
          selectedKeys={selectedRun}
          // onSelectionChange={handleSelectRun}
          onChange={(e) => setSelectRun(e.target.value)}
          isDisabled={custDesc !== ""}
          className='pb-2 max-w-[242px]'
          isRequired={true}
        >
          {runSelect.map((runs) => (
            <SelectItem key={runs.key}>
              {runs.label}
            </SelectItem>
          ))}
        </Select>
        <Input
          type='number'
          onKeyDown={handleKeyDown}
          className='max-w-[112px]'
          label="Minutes"
          value={runMinutes}
          onChange={(e) => setRunMinutes(e.target.value)}
          isRequired={selectedRun?true:false}
          isDisabled={custDesc !== ""}
          key="runMinutes"
        />

        <div className="flex flex-col items-center md:items-start text-center md:text-left px-4">
          <Button isDisabled={!selectedRun || custDesc !== ""}
            className='mt-2'
            type="submit" color="primary">
            Add Activity
          </Button>
        </div>
      </div>
      <Divider className="my-1" />
      <Accordion className='hover:border-current hover:border hover:rounded-lg' isCompact >
        <AccordionItem key="1" aria-label="Custom Route"
          title={<div className='flex text-primary text-lg'> <FaPlusCircle className='mt-1 mr-2' />Alternative: Add Custom Route</div>}
        >
          <div className='flex flex-col space-y-4 md:flex-row md:space-y-0'>
            <Select
              label="Mode"
              variant="bordered"
              placeholder="Run/Walk/Ruck"
              selectedKeys={custMode}
              // onSelectionChange={handleSelectMode}
              onChange={(e) => {setCustMode(e.target.value)}}
              className='max-w-[142px]'
              isRequired={custDesc !== ""}
            >
              <SelectItem key="run">Run</SelectItem>
              <SelectItem key="walk">Walk</SelectItem>
              <SelectItem key="ruck">Ruck</SelectItem>
            </Select>
            <Input
              type="text"
              label="Name or Short Description"
              className="pb-2"
              variant="bordered"
              value={custDesc}
              isRequired={custMode?true:false}
              onChange={(e) => {setCustDesc(e.target.value)}}
              maxLength={50}
            />
          </div>
          <div className='flex flex-col space-y-4 md:flex-row md:space-x-4 md:space-y-0'>
            <Input
              type='number'
              min={0}
              onKeyDown={handleKeyDown}
              className='pb-2 max-w-[142px]'
              label="Minutes"
              variant="bordered"
              value={custMinutes}
              isRequired={custDesc !== ""}
              onChange={(e) => setCustMinutes(e.target.value)}
              key="custMinutes"
            />
            <Input
              type='number'
              min={0}
              pattern="$0|[1-9]\d*(\.\d+)?"
              onKeyDown={handleKeyDown}
              className='pb-2 max-w-[142px]'
              label="Distance"
              isRequired={custDesc !== ""}
              variant="bordered"
              value={custDist}
              onChange={(e) => setCustDist(e.target.value)}
            />
            <RadioGroup
              orientation="horizontal"
              label="Units"
              color="primary"
              className='overflow-hidden min-w-[142px] text-sm '
              value={custUnit}
              onChange={(e) => setCustUnit(e.target.value)}
              size='sm'
            >
              <Radio value="km">Kilometers</Radio>
              <Radio value="mi">Miles</Radio>
              <Radio value="steps">Steps</Radio>
            </RadioGroup>

          </div>
          <Divider className='mt-4' />

          <Accordion className='px-0 pt-0 mt-0' isCompact>
            <AccordionItem className='overflow-x-hidden' key="2" aria-label="Advanced" title={<div className='flex'> <FaPlusCircle className='mt-1 mr-2' />Advanced: GPX and Waypoints</div>}>
              <div><p className='text-lg'>In the future we hope to accept GPX uploads. 🤷</p></div>
            </AccordionItem>
          </Accordion>
          <div className="flex flex-col items-center text-center px-4">
            <Button isDisabled={custDesc == ""} className='mt-2 mb-2' type="submit" color="primary"> Add Custom Route </Button>
          </div>
        </AccordionItem>

      </Accordion>
      <Divider className="my-2" />


    </form>
  );
};

export default ManualFormComponent;