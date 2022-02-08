/**
 * @license
 * Copyright 2014-2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/// <reference types="google.visualization" />
import { LitElement } from 'lit';
import { DataTableLike } from './loader.js';
/**
 * `google-chart` encapsulates Google Charts as a web component, allowing you to
 * easily visualize data. From simple line charts to complex hierarchical tree
 * maps, the chart element provides a number of ready-to-use chart types.
 *
 * ```html
 * <google-chart
 *     type='pie'
 *     options='{"title": "Distribution of days in 2001Q1"}'
 *     cols='[{"label":"Month", "type":"string"}, {"label":"Days",
 *         "type":"number"}]' rows='[["Jan", 31],["Feb", 28],["Mar", 31]]'>
 *   </google-chart>
 * ```
 *
 * Note: if you're passing JSON as attributes, single quotes are necessary to be
 * valid JSON. See
 * https://www.polymer-project.org/1.0/docs/devguide/properties#configuring-object-and-array-properties.
 *
 * Height and width are specified as style attributes:
 * ```css
 * google-chart {
 *   height: 300px;
 *   width: 50em;
 * }
 * ```
 *
 * Data can be provided in one of three ways:
 *
 * - Via the `cols` and `rows` attributes:
 *   ```
 *   cols='[{"label":"Mth", "type":"string"},{"label":"Days", "type":"number"}]'
 *   rows='[["Jan", 31],["Feb", 28],["Mar", 31]]'
 *   ```
 *
 * - Via the `data` attribute, passing in the data directly:
 *   ```
 *   data='[["Month", "Days"], ["Jan", 31], ["Feb", 28], ["Mar", 31]]'
 *   ```
 *
 * - Via the `data` attribute, passing in the URL to a resource containing the
 *   data, in JSON format:
 *   ```
 *   data='http://example.com/chart-data.json'
 *   ```
 *
 * - Via the `data` attribute, passing in a Google DataTable object:
 *   ```
 *   data='{{dataTable}}'
 *   ```
 *
 * - Via the `view` attribute, passing in a Google DataView object:
 *   ```
 *   view='{{dataView}}'
 *   ```
 *
 * You can display the charts in locales other than "en" by setting the `lang`
 * attribute on the `html` tag of your document:
 * ```
 * <html lang="ja">
 * ```
 *
 * @demo demo/index.html
 */
export declare class GoogleChart extends LitElement {
    /** @nocollapse */
    static styles: import("lit").CSSResult;
    /**
     * Fired after a chart type is rendered and ready for interaction.
     *
     * @event google-chart-ready
     * @param {{chart: !Object}} detail The raw chart object.
     */
    /**
     * Fired when the user makes a selection in the chart.
     *
     * @event google-chart-select
     * @param {{chart: !Object}} detail The raw chart object.
     */
    /**
     * Type of the chart.
     *
     * Should be one of:
     * - `area`
     * - `(md-)bar`
     * - `bubble`
     * - `calendar`
     * - `candlestick`
     * - `column`
     * - `combo`
     * - `gantt`
     * - `gauge`
     * - `geo`
     * - `histogram`
     * - `(md-)line`
     * - `org`
     * - `pie`
     * - `sankey`
     * - `(md-)scatter`
     * - `stepped-area`
     * - `table`
     * - `timeline`
     * - `treemap`
     * - `wordtree`
     *
     * See <a
     * href="https://google-developers.appspot.com/chart/interactive/docs/gallery">Google
     * Visualization API reference (Chart Gallery)</a> for details.
     */
    type: string;
    /**
     * Enumerates the chart events that should be fired.
     *
     * Charts support a variety of events. By default, this element only
     * fires on `ready` and `select`. If you would like to be notified of
     * other chart events, use this property to list them.
     * Events `ready` and `select` are always fired.
     *
     * Changes to this property are _not_ observed. Events are attached only
     * at chart construction time.
     */
    events: string[];
    /**
     * Sets the options for the chart.
     *
     * Example:
     * ```
     * {
     *   title: "Chart title goes here",
     *   hAxis: {title: "Categories"},
     *   vAxis: {title: "Values", minValue: 0, maxValue: 2},
     *   legend: "none"
     * }
     * ```
     * See <a
     * href="https://google-developers.appspot.com/chart/interactive/docs/gallery">Google
     * Visualization API reference (Chart Gallery)</a> for the options available
     * to each chart type.
     *
     * Setting this property always redraws the chart. If you would like to make
     * changes to a sub-property, be sure to reassign the property:
     * ```
     * const options = googleChart.options;
     * options.vAxis.logScale = true;
     * googleChart.options = options;
     * ```
     * (Note: Missing parent properties are not automatically created.)
     */
    options: {} | undefined;
    /**
     * Sets the data columns for this object.
     *
     * When specifying data with `cols` you must also specify `rows`, and
     * not specify `data`.
     *
     * Example:
     * <pre>[{label: "Categories", type: "string"},
     *  {label: "Value", type: "number"}]</pre>
     * See <a
     * href="https://google-developers.appspot.com/chart/interactive/docs/reference#DataTable_addColumn">Google
     * Visualization API reference (addColumn)</a> for column definition format.
     */
    cols: unknown[] | undefined;
    /**
     * Sets the data rows for this object.
     *
     * When specifying data with `rows` you must also specify `cols`, and
     * not specify `data`.
     *
     * Example:
     * <pre>[["Category 1", 1.0],
     *  ["Category 2", 1.1]]</pre>
     * See <a
     * href="https://google-developers.appspot.com/chart/interactive/docs/reference#addrow">Google
     * Visualization API reference (addRow)</a> for row format.
     */
    rows: unknown[][] | undefined;
    /**
     * Sets the entire dataset for this object.
     * Can be used to provide the data directly, or to provide a URL from
     * which to request the data.
     *
     * The data format can be a two-dimensional array or the DataTable format
     * expected by Google Charts.
     * See <a
     * href="https://google-developers.appspot.com/chart/interactive/docs/reference#DataTable">Google
     * Visualization API reference (DataTable constructor)</a> for data table
     * format details.
     *
     * When specifying data with `data` you must not specify `cols` or `rows`.
     *
     * Example:
     * ```
     * [["Categories", "Value"],
     *  ["Category 1", 1.0],
     *  ["Category 2", 1.1]]
     * ```
     */
    data: DataTableLike | string | undefined;
    /**
     * Sets the entire dataset for this object to a Google DataView.
     *
     * See <a
     * href="https://google-developers.appspot.com/chart/interactive/docs/reference#dataview-class">Google
     * Visualization API reference (DataView)</a> for details.
     *
     * When specifying data with `view` you must not specify `data`, `cols` or
     * `rows`.
     */
    view: google.visualization.DataView | undefined;
    /**
     * Selected datapoint(s) in the chart.
     *
     * An array of objects, each with a numeric row and/or column property.
     * `row` and `column` are the zero-based row or column number of an item
     * in the data table to select.
     *
     * To select a whole column, set row to null;
     * to select a whole row, set column to null.
     *
     * Example:
     * ```
     * [{row:0,column:1}, {row:1, column:null}]
     * ```
     */
    selection: google.visualization.ChartSelection[] | undefined;
    /**
     * Whether the chart is currently rendered.
     * @export
     */
    drawn: boolean;
    /**
     * Internal data displayed on the chart.
     */
    _data: google.visualization.DataTable | google.visualization.DataView | undefined;
    /**
     * Internal chart object.
     */
    private chartWrapper;
    private redrawTimeoutId;
    /** @override */
    protected render(): import("lit-html").TemplateResult<1>;
    /** @override */
    protected firstUpdated(): void;
    /** @override */
    protected updated(changedProperties: Map<string, unknown>): void;
    /** Reacts to chart type change. */
    private typeChanged;
    /**
     * Adds listeners to propagate events from the chart.
     */
    private propagateEvents;
    /** Sets the selectiton on the chart. */
    private selectionChanged;
    /**
     * Redraws the chart.
     *
     * Called automatically when data/type/selection attributes change.
     * Call manually to handle view updates, page resizes, etc.
     */
    redraw(): void;
    /**
     * Returns the chart serialized as an image URI.
     *
     * Call this after the chart is drawn (`google-chart-ready` event).
     */
    get imageURI(): string | null;
    /** Handles changes to the `view` attribute. */
    private viewChanged;
    /** Handles changes to the rows & columns attributes. */
    private rowsOrColumnsChanged;
    /**
     * Handles changes to the `data` attribute.
     */
    private dataChanged;
    /**
     * Queries global document head for Google Charts `link#load-css-*` and clones
     * them into the local root's `div#styles` element for shadow dom support.
     */
    private localizeGlobalStylesheets;
}
declare global {
    interface HTMLElementTagNameMap {
        'google-chart': GoogleChart;
    }
}
//# sourceMappingURL=google-chart.d.ts.map