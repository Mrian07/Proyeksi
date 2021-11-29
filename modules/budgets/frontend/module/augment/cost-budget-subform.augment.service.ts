

import { Injectable } from "@angular/core";
import { HttpClient } from '@angular/common/http';
import { HalResourceNotificationService } from "core-app/features/hal/services/hal-resource-notification.service";

@Injectable()
export class CostBudgetSubformAugmentService {

  constructor(private halNotification:HalResourceNotificationService,
              private http:HttpClient) {
  }

  listen() {
    jQuery('costs-budget-subform').each((i, match) => {
      const el = jQuery(match);

      const container = el.find('.budget-item-container');
      const templateEl = el.find('.budget-row-template');
      templateEl.detach();
      const template = templateEl[0].outerHTML;
      let rowIndex = parseInt(el.attr('item-count') as string);

      // Refresh row on changes
      el.on('change', '.budget-item-value', (evt) => {
        const row = jQuery(evt.target).closest('.cost_entry');
        this.refreshRow(el, row.attr('id') as string);
      });

      el.on('click', '.delete-budget-item', (evt) => {
        evt.preventDefault();
        jQuery(evt.target).closest('.cost_entry').remove();
        return false;
      });

      // Add new row handler
      el.find('.budget-add-row').click((evt) => {
        evt.preventDefault();
        const row = jQuery(template.replace(/INDEX/g, rowIndex.toString()));
        row.show();
        row.removeClass('budget-row-template');
        container.append(row);
        rowIndex += 1;
        return false;
      });
    });
  }

  /**
   * Refreshes the given row after updating values
   */
  public refreshRow(el:JQuery, row_identifier:string) {
    const row = el.find('#' + row_identifier);
    const request = this.buildRefreshRequest(row, row_identifier);

    this.http
      .post(
        el.attr('update-url')!,
        request,
        {
          headers: { 'Accept': 'application/json' },
          withCredentials: true
        })
      .subscribe(
        (data:any) => {
          _.each(data, (val:string, selector:string) => {
            const element = document.getElementById(selector) as HTMLElement|HTMLInputElement|undefined;
            if (element instanceof HTMLInputElement) {
              element.value = val;
            } else if (element) {
              element.textContent = val;
            }
          });
        },
        (error:any) => this.halNotification.handleRawError(error)
      );
  }

  /**
   * Returns the params for the update request
   */
  private buildRefreshRequest(row:JQuery, row_identifier:string) {
    const request:any = {
      element_id: row_identifier,
      fixed_date: jQuery('#budget_fixed_date').val()
    };

    // Augment common values with specific values for this type
    row.find('.budget-item-value').each((_i:number, el:any) => {
      const field = jQuery(el);
      request[field.data('requestKey')] = field.val() || '0';
    });

    return request;
  }
}
