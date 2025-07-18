import { Link, useParams } from '@tanstack/react-router';
import { ExternalLink } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { HoverCard, HoverCardContent, HoverCardTrigger } from '@/components/ui/hover-card';
import { ScrollArea, ScrollBar } from '@/components/ui/scroll-area';
import { SidebarMenuButton, SidebarMenuItem } from '@/components/ui/sidebar';
import type { QueryRecord } from '@/orval/models';

import { SQLEditor } from '../../sql-editor';
import { useSqlEditorSettingsStore } from '../../sql-editor-settings-store';
import { SqlEditorRightPanelQueryCopyButton } from './sql-editor-right-panel-query-copy-button';
import { SqlEditorRightPanelQueryItem } from './sql-editor-right-panel-query-item';

interface SqlEditorRightPanelQueriesProps {
  query: QueryRecord;
}

export const SqlEditorRightPanelQuery = ({ query }: SqlEditorRightPanelQueriesProps) => {
  const { worksheetId } = useParams({ from: '/sql-editor/$worksheetId/' });
  const selectedQueryRecord = useSqlEditorSettingsStore((state) =>
    state.getSelectedQueryRecord(+worksheetId),
  );
  const setSelectedQueryRecord = useSqlEditorSettingsStore((state) => state.setSelectedQueryRecord);

  return (
    <HoverCard key={query.id} openDelay={100} closeDelay={10}>
      <HoverCardTrigger>
        <SidebarMenuItem>
          <SidebarMenuButton
            isActive={query.id === selectedQueryRecord?.id}
            onClick={() => setSelectedQueryRecord(+worksheetId, query)}
            className="hover:bg-hover data-[active=true]:bg-hover! data-[active=true]:font-light"
          >
            <SqlEditorRightPanelQueryItem
              status={query.status}
              query={query.query}
              error={query.error}
              time={new Date(query.startTime).toLocaleTimeString('en-US', {
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
              })}
            />
          </SidebarMenuButton>
        </SidebarMenuItem>
      </HoverCardTrigger>
      <HoverCardContent className="flex size-full max-h-[220px] max-w-[400px] min-w-[240px] flex-1 flex-col p-1">
        <div className="bg-background-secondary rounded">
          <div className="mb-1 flex items-center justify-between p-2 pb-0">
            <Link to="/queries/$queryId" params={{ queryId: query.id.toString() }}>
              <Button
                variant="outline"
                className="hover:bg-hover! h-7! justify-start bg-transparent! px-2!"
              >
                <ExternalLink />
                <span className="text-sm font-light">Open query details</span>
              </Button>
            </Link>
            <SqlEditorRightPanelQueryCopyButton query={query} />
          </div>
          {/* TODO: Hardcode */}
          <ScrollArea className="p-2 [&>[data-radix-scroll-area-viewport]]:max-h-[calc(200px-16px-36px-12px)]">
            <SQLEditor readonly content={query.query} />
            <ScrollBar orientation="vertical" />
          </ScrollArea>
        </div>
      </HoverCardContent>
    </HoverCard>
  );
};
