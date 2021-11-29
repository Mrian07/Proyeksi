

export type WorkPackageTableConfigurationObject = Partial<{ [field in keyof WorkPackageTableConfiguration]:string|boolean }>;

export class WorkPackageTableConfiguration {
  /** Render the table results, set to false when only wanting the table initialization */
  public tableVisible = true;

  /** Render the table as compact style */
  public compactTableStyle = false;

  /** Render the action column (last column) with the actions defined in the TableActionsService */
  public actionsColumnEnabled = true;

  /** Whether the work package context menu is enabled */
  public contextMenuEnabled = true;

  /** Whether the column dropdown menu is enabled */
  public columnMenuEnabled = true;

  /** Whether the query should be resolved using the current project identifier */
  public projectContext = true;

  /** Whether the embedded table should live within a specific project context (e.g., given by its parent) */
  public projectIdentifier:string|null = null;

  /** Whether inline create is enabled */
  public inlineCreateEnabled = true;

  /** Whether the hierarchy toggler item in the subject column is enabled */
  public hierarchyToggleEnabled = true;

  /** Whether this table supports drag and drop */
  public dragAndDropEnabled = false;

  /** Whether this table is in an embedded context */
  public isEmbedded = false;

  /** Whether the work packages shall be shown in cards instead of a table */
  public isCardView = false;

  /** Whether this table provides a UI for filters */
  public withFilters = false;

  /** Whether the filters are expanded */
  public filtersExpanded = false;

  /** Whether the button to open filters shall be visible */
  public showFilterButton = false;

  /** Whether this table provides a UI for filters */
  public filterButtonText:string = I18n.t('js.button_filter');

  constructor(providedConfig:WorkPackageTableConfigurationObject) {
    _.each(providedConfig, (value, k) => {
      const key = (k as keyof WorkPackageTableConfiguration);
      (this as any)[key] = value;
    });
  }
}
