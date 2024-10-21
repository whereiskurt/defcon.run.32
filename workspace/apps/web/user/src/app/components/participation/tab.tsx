'use client';

import { Button, Modal, ModalBody, ModalContent, ModalFooter, ModalHeader, Tab, Table, TableBody, TableCell, TableColumn, TableHeader, TableRow, Tabs, useDisclosure } from "@nextui-org/react";
import { useEffect, useState } from "react";
import { FaHistory, FaPlusCircle, FaStrava, FaUser } from "react-icons/fa";
import ManaulInputForm, { RunSelect } from "./manual";
import { Participation } from "@defcon.run/web/db";
import { getCsrfToken } from "next-auth/react";

interface BodyProps {
  participations: Participation[];
  runSelect: RunSelect[];
  session: any;
  className?: string;
  searchParams: any;
}

export default function Body({ session, runSelect, participations, className = "", searchParams }: BodyProps) {
  const [selectedKeys, setSelectedKeys] = useState<Set<React.Key>>(new Set());
  const [csrfToken, setCsrfToken] = useState<string | null>(null)

  const [showTabKey, setShowTabKey] = useState("history");
  useEffect(() => {
    if (!searchParams['show']) return;
    if (searchParams['show'] === "manual") {
      setShowTabKey("manual");
    } else if (searchParams['show'] === "strava") {
      //TODO: Release add from Strava: setShowTabKey("strava");
      setShowTabKey("manual");
    }

    (async () => {
      const token = await getCsrfToken();
      setCsrfToken(token);
    })();

  }, [searchParams]);

  const handleSelectionChange = (keys: any) => {
    setSelectedKeys(keys);
  };

  const [pdata, setPData] = useState(participations);

  const { isOpen, onOpen: onOpenDelete, onClose: onCloseDelete } = useDisclosure();

  const doDelete = () => {
    const keysArray = [...selectedKeys];
    handleDelete(keysArray[0].toString())
    onCloseDelete();
  }

  const handleDelete = async (id: string) => {

    try {
      const res = await fetch("/api/participation", {
        method: "DELETE",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ csrfToken, payload: { activityId: id } }),
      })

      if (!res.ok || res.status != 200) {
        const errorData = await res.json()
        throw new Error(errorData.error)
      } else {
        setPData(pdata.filter((item: { id: string; }) => item.id !== id));
      }
    } catch (error: any) {
      console.log(`Error ${JSON.stringify(error)}`);
    }

  };

  return (
    <div className={className}>
      {ModalDelete(isOpen, onCloseDelete, doDelete)}

      <Tabs
        selectedKey={showTabKey}
        onSelectionChange={(key) => { setShowTabKey(`${key}`); setSelectedKeys(new Set()) }}
        className="inline" size="lg" key="PTabSelector" aria-label="Participation Tabs" radius="lg"
      >
        <Tab key="history"
          title={<div className="flex"><FaHistory className="mr-1" size={"20px"} />Activities</div>}
        >

          <Table
            color="danger"
            selectionMode="single"
            showSelectionCheckboxes={false}
            aria-label="History of runs"
            isCompact={false}
            onSelectionChange={handleSelectionChange}
          >
            <TableHeader>
              <TableColumn className="text-lg">Description</TableColumn>
              <TableColumn className="text-lg">DC32</TableColumn>
            </TableHeader>
            <TableBody>
              {pdata.map((item: any) => (
                <TableRow key={item.id}>
                  <TableCell className="">{item.description}</TableCell>
                  <TableCell><div>{item.dts}</div></TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
          <div className="flex flex-col items-center text-center pt-4">
            <Button onClick={onOpenDelete} color="danger" variant="bordered" isDisabled={Array.from(selectedKeys).length === 0} startContent={<FaUser size={"20px"} />}>
              Delete Activity
            </Button>
          </div>
        </Tab>
        <Tab key="manual" title={<div className="flex"><FaPlusCircle className="mr-1" size={"20px"} />New Activity</div>}>
          <ManaulInputForm runSelect={runSelect} setPData={setPData} setShowTabKey={setShowTabKey} participations={pdata} />
        </Tab>
        <Tab key="strava" title={<div className="flex"><FaStrava className="mr-1" color="red" size={"20px"} />From Strava</div>} >
              <div className="text-4xl text-center pt-4">🚧 Work in progress!! 🚧</div>
        </Tab>
      </Tabs>
    </div>
  );
}

function ModalDelete(isOpen: boolean, onClose: () => void, onDelete: () => void) {
  return <Modal
    size={"sm"}
    placement="center"
    isOpen={isOpen}
    backdrop="blur"
    onClose={onClose}
  >
    <ModalContent>
      {() => (
        <>
          <ModalHeader className="flex flex-col gap-1">Participation</ModalHeader>
          <ModalBody>
            <p>Do you want to delete the selected activity? </p>
          </ModalBody>
          <ModalFooter>
            <Button color="danger" variant="light" onClick={onDelete}>
              Delete
            </Button>
            <Button color="primary" onClick={onClose}>
              Keep
            </Button>
          </ModalFooter>
        </>
      )}
    </ModalContent>
  </Modal>;
}