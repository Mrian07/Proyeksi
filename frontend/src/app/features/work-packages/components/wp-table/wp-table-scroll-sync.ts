

export const selectorTableSide = '.work-packages-tabletimeline--table-side';
export const selectorTimelineSide = '.work-packages-tabletimeline--timeline-side';
const jQueryScrollSyncEventNamespace = '.scroll-sync';
const scrollStep = 15;

function getXandYScrollDeltas(ev:WheelEvent):[number, number] {
  let x = ev.deltaX;
  let y = ev.deltaY;

  if (ev.shiftKey) {
    x = y;
    y = 0;
  }

  return [x, y];
}

function getPlattformAgnosticScrollAmount(originalValue:number) {
  if (originalValue === 0) {
    return originalValue;
  }

  let delta = scrollStep;

  // Browser-specific logic
  // TODO

  if (originalValue < 0) {
    delta *= -1;
  }
  return delta;
}

function syncWheelEvent(jev:JQuery.TriggeredEvent, elementTable:JQuery, elementTimeline:JQuery) {
  const scrollTarget = jev.target;
  const ev:WheelEvent = jev.originalEvent as any;
  let [deltaX, deltaY] = getXandYScrollDeltas(ev);

  if (deltaY === 0) {
    return;
  }

  deltaX = getPlattformAgnosticScrollAmount(deltaX); // apply only in target div
  deltaY = getPlattformAgnosticScrollAmount(deltaY); // apply in both divs

  window.requestAnimationFrame(() => {
    elementTable[0].scrollTop = elementTable[0].scrollTop + deltaY;
    elementTimeline[0].scrollTop = elementTable[0].scrollTop + deltaY;

    scrollTarget.scrollLeft += deltaX;
  });
}

/**
 * Activate or deactivate the scroll-sync between the table and timeline view.
 *
 * @param $element true if the timeline is visible, false otherwise.
 */
export function createScrollSync($element:JQuery) {
  const elTable = jQuery($element).find(selectorTableSide);
  const elTimeline = jQuery($element).find(selectorTimelineSide);

  return (timelineVisible:boolean) => {
    // state vars
    let syncedLeft = false;
    let syncedRight = false;

    if (timelineVisible) {
      // setup event listener for table
      elTable.on(`wheel${jQueryScrollSyncEventNamespace}`, (jev:JQuery.TriggeredEvent) => {
        syncWheelEvent(jev, elTable, elTimeline);
      });
      elTable.on(`scroll${jQueryScrollSyncEventNamespace}`, (ev:JQuery.TriggeredEvent) => {
        syncedLeft = true;
        if (!syncedRight) {
          elTimeline[0].scrollTop = ev.target.scrollTop;
        }
        if (syncedLeft && syncedRight) {
          syncedLeft = false;
          syncedRight = false;
        }
      });

      // setup event listener for timeline
      elTimeline.on(`wheel${jQueryScrollSyncEventNamespace}`, (jev:JQuery.TriggeredEvent) => {
        syncWheelEvent(jev, elTable, elTimeline);
      });
      elTimeline.on(`scroll${jQueryScrollSyncEventNamespace}`, (ev:JQuery.TriggeredEvent) => {
        syncedRight = true;
        if (!syncedLeft) {
          elTable[0].scrollTop = ev.target.scrollTop;
        }
        if (syncedLeft && syncedRight) {
          syncedLeft = false;
          syncedRight = false;
        }
      });
    } else {
      elTable.off(jQueryScrollSyncEventNamespace);
    }
  };
}
