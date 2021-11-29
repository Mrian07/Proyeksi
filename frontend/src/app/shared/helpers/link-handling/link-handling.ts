

export function isClickedWithModifier(event:MouseEvent|JQuery.TriggeredEvent) {
  const modifier = event.ctrlKey || event.shiftKey || event.metaKey;
  const middleButton = event.button === 1;

  return modifier || middleButton;
}
