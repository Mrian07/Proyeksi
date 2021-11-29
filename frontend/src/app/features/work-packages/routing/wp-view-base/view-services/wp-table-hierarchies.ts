

export class WorkPackageViewHierarchies {
  public isVisible = false;

  public last:string|null = null;

  public collapsed:{ [workPackageId:string]:boolean } = {};

  constructor(visible:boolean) {
    this.isVisible = visible;
  }
}
