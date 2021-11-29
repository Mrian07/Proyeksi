

export class PaginationInstance {
  constructor(public page:number,
    public total:number,
    public perPage:number) {
  }

  public getLowerPageBound() {
    return this.perPage * (this.page - 1) + 1;
  }

  public getUpperPageBound(limit:number) {
    return Math.min(this.perPage * this.page, limit);
  }

  public nextPage() {
    this.page += 1;
  }

  public previousPage() {
    this.page -= 1;
  }
}
