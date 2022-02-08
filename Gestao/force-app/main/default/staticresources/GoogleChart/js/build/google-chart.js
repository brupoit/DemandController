"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var exports = {};
Object.defineProperty(exports, "__esModule", { value: true });
exports.GoogleChart = void 0;
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
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function")
        r = Reflect.decorate(decorators, target, key, desc);
    else
        for (var i = decorators.length - 1; i >= 0; i--)
            if (d = decorators[i])
                r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
const lit_1 = require("lit");
const decorators_js_1 = require("lit/decorators.js");
const loader_js_1 = require("./loader.js");
const DEFAULT_EVENTS = ['ready', 'select'];
/**
 * Constructor names for supported chart types.
 *
 * `ChartWrapper` expects a constructor name and assumes `google.visualization`
 *  as the default namespace.
 */
const CHART_TYPES = {
    'area': 'AreaChart',
    'bar': 'BarChart',
    'md-bar': 'google.charts.Bar',
    'bubble': 'BubbleChart',
    'calendar': 'Calendar',
    'candlestick': 'CandlestickChart',
    'column': 'ColumnChart',
    'combo': 'ComboChart',
    'gantt': 'Gantt',
    'gauge': 'Gauge',
    'geo': 'GeoChart',
    'histogram': 'Histogram',
    'line': 'LineChart',
    'md-line': 'google.charts.Line',
    'org': 'OrgChart',
    'pie': 'PieChart',
    'sankey': 'Sankey',
    'scatter': 'ScatterChart',
    'md-scatter': 'google.charts.Scatter',
    'stepped-area': 'SteppedAreaChart',
    'table': 'Table',
    'timeline': 'Timeline',
    'treemap': 'TreeMap',
    'wordtree': 'WordTree',
};
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
class GoogleChart extends lit_1.LitElement {
    constructor() {
        super(...arguments);
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
        this.type = 'column';
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
        this.events = [];
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
        this.options = undefined;
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
        this.cols = undefined;
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
        this.rows = undefined;
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
        // Note: type: String, because it is parsed manually in the observer.
        this.data = undefined;
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
        this.view = undefined;
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
        this.selection = undefined;
        /**
         * Whether the chart is currently rendered.
         * @export
         */
        this.drawn = false;
        /**
         * Internal data displayed on the chart.
         */
        // tslint:disable-next-line:enforce-name-casing
        this._data = undefined;
        /**
         * Internal chart object.
         */
        this.chartWrapper = null;
        this.redrawTimeoutId = undefined;
    }
    /** @override */
    render() {
        return (0, lit_1.html) `
      <div id="styles"></div>
      <div id="chartdiv"></div>
    `;
    }
    /** @override */
    firstUpdated() {
        (0, loader_js_1.createChartWrapper)(this.shadowRoot.getElementById('chartdiv'))
            .then(chartWrapper => {
            this.chartWrapper = chartWrapper;
            this.typeChanged();
            google.visualization.events.addListener(chartWrapper, 'ready', () => {
                this.drawn = true;
            });
            google.visualization.events.addListener(chartWrapper, 'select', () => {
                this.selection = chartWrapper.getChart().getSelection();
            });
            this.propagateEvents(DEFAULT_EVENTS, chartWrapper);
        });
    }
    /** @override */
    updated(changedProperties) {
        if (changedProperties.has('type'))
            this.typeChanged();
        if (changedProperties.has('rows') || changedProperties.has('cols')) {
            this.rowsOrColumnsChanged();
        }
        if (changedProperties.has('data'))
            this.dataChanged();
        if (changedProperties.has('view'))
            this.viewChanged();
        if (changedProperties.has('_data') ||
            changedProperties.has('options'))
            this.redraw();
        if (changedProperties.has('selection'))
            this.selectionChanged();
    }
    /** Reacts to chart type change. */
    typeChanged() {
        if (this.chartWrapper == null)
            return;
        this.chartWrapper.setChartType(CHART_TYPES[this.type] || this.type);
        const lastChart = this.chartWrapper.getChart();
        google.visualization.events.addOneTimeListener(this.chartWrapper, 'ready', () => {
            // Ready event fires after `chartWrapper` is initialized.
            const chart = this.chartWrapper.getChart();
            if (chart !== lastChart) {
                this.propagateEvents(this.events.filter((eventName) => !DEFAULT_EVENTS.includes(eventName)), chart);
            }
            const stylesDiv = this.shadowRoot.getElementById('styles');
            if (!stylesDiv.children.length) {
                this.localizeGlobalStylesheets(stylesDiv);
            }
            if (this.selection) {
                this.selectionChanged();
            }
        });
        this.redraw();
    }
    /**
     * Adds listeners to propagate events from the chart.
     */
    propagateEvents(events, eventTarget) {
        for (const eventName of events) {
            google.visualization.events.addListener(eventTarget, eventName, (event) => {
                this.dispatchEvent(new CustomEvent(`google-chart-${eventName}`, {
                    bubbles: true,
                    composed: true,
                    detail: {
                        // Events fire after `chartWrapper` is initialized.
                        chart: this.chartWrapper.getChart(),
                        data: event,
                    }
                }));
            });
        }
    }
    /** Sets the selectiton on the chart. */
    selectionChanged() {
        if (this.chartWrapper == null)
            return;
        const chart = this.chartWrapper.getChart();
        if (chart == null)
            return;
        if (chart.setSelection) {
            // Workaround for timeline chart which emits select event on setSelection.
            // See issue #256.
            if (this.type === 'timeline') {
                const oldSelection = JSON.stringify(chart.getSelection());
                const newSelection = JSON.stringify(this.selection);
                if (newSelection === oldSelection)
                    return;
            }
            chart.setSelection(this.selection);
        }
    }
    /**
     * Redraws the chart.
     *
     * Called automatically when data/type/selection attributes change.
     * Call manually to handle view updates, page resizes, etc.
     */
    redraw() {
        if (this.chartWrapper == null || this._data == null)
            return;
        // `ChartWrapper` can be initialized with `DataView` instead of `DataTable`.
        this.chartWrapper.setDataTable(this._data);
        this.chartWrapper.setOptions(this.options || {});
        this.drawn = false;
        if (this.redrawTimeoutId !== undefined)
            clearTimeout(this.redrawTimeoutId);
        this.redrawTimeoutId = window.setTimeout(() => {
            // Drawing happens after `chartWrapper` is initialized.
            this.chartWrapper.draw();
        }, 5);
    }
    /**
     * Returns the chart serialized as an image URI.
     *
     * Call this after the chart is drawn (`google-chart-ready` event).
     */
    get imageURI() {
        if (this.chartWrapper == null)
            return null;
        const chart = this.chartWrapper.getChart();
        return chart && chart.getImageURI();
    }
    /** Handles changes to the `view` attribute. */
    viewChanged() {
        if (!this.view)
            return;
        this._data = this.view;
    }
    /** Handles changes to the rows & columns attributes. */
    rowsOrColumnsChanged() {
        return __awaiter(this, void 0, void 0, function* () {
            const { rows, cols } = this;
            if (!rows || !cols)
                return;
            try {
                const dt = yield (0, loader_js_1.dataTable)({ cols });
                dt.addRows(rows);
                this._data = dt;
            }
            catch (reason) {
                this.shadowRoot.getElementById('chartdiv').textContent = String(reason);
            }
        });
    }
    /**
     * Handles changes to the `data` attribute.
     */
    dataChanged() {
        let data = this.data;
        let dataPromise;
        if (!data) {
            return;
        }
        let isString = false;
        // Polymer 2 will not call observer if type:Object is set and fails, so
        // we must parse the string ourselves.
        try {
            // Try to deserialize the value of the `data` property which might be a
            // serialized array.
            data = JSON.parse(data);
        }
        catch (e) {
            isString = typeof data === 'string' || data instanceof String;
        }
        if (isString) {
            // Load data asynchronously, from external URL.
            dataPromise = fetch(data).then(response => response.json());
        }
        else {
            // Data is all ready to be processed.
            dataPromise = Promise.resolve(data);
        }
        dataPromise.then(loader_js_1.dataTable).then(data => {
            this._data = data;
        });
    }
    /**
     * Queries global document head for Google Charts `link#load-css-*` and clones
     * them into the local root's `div#styles` element for shadow dom support.
     */
    localizeGlobalStylesheets(stylesDiv) {
        // Get all Google Charts stylesheets.
        const stylesheets = Array.from(document.head.querySelectorAll('link[rel="stylesheet"][type="text/css"][id^="load-css-"]'));
        for (const stylesheet of stylesheets) {
            // Clone necessary stylesheet attributes.
            const clonedStylesheet = document.createElement('link');
            clonedStylesheet.setAttribute('rel', 'stylesheet');
            clonedStylesheet.setAttribute('type', 'text/css');
            // `href` is always present.
            clonedStylesheet.setAttribute('href', stylesheet.getAttribute('href'));
            stylesDiv.appendChild(clonedStylesheet);
        }
    }
}
exports.GoogleChart = GoogleChart;
/** @nocollapse */
GoogleChart.styles = (0, lit_1.css) `
    :host {
      display: -webkit-flex;
      display: -ms-flex;
      display: flex;
      margin: 0;
      padding: 0;
      width: 400px;
      height: 300px;
    }

    :host([hidden]) {
      display: none;
    }

    :host([type="gauge"]) {
      width: 300px;
      height: 300px;
    }

    #chartdiv {
      width: 100%;
    }

    /* Workaround for slow initial ready event for tables. */
    .google-visualization-table-loadtest {
      padding-left: 6px;
    }
  `;
__decorate([
    (0, decorators_js_1.property)({ type: String, reflect: true })
], GoogleChart.prototype, "type", void 0);
__decorate([
    (0, decorators_js_1.property)({ type: Array })
], GoogleChart.prototype, "events", void 0);
__decorate([
    (0, decorators_js_1.property)({ type: Object, hasChanged: () => true })
], GoogleChart.prototype, "options", void 0);
__decorate([
    (0, decorators_js_1.property)({ type: Array })
], GoogleChart.prototype, "cols", void 0);
__decorate([
    (0, decorators_js_1.property)({ type: Array })
], GoogleChart.prototype, "rows", void 0);
__decorate([
    (0, decorators_js_1.property)({ type: String })
], GoogleChart.prototype, "data", void 0);
__decorate([
    (0, decorators_js_1.property)({ type: Object })
], GoogleChart.prototype, "view", void 0);
__decorate([
    (0, decorators_js_1.property)({ type: Array })
], GoogleChart.prototype, "selection", void 0);
__decorate([
    (0, decorators_js_1.property)({ type: Object })
], GoogleChart.prototype, "_data", void 0);
customElements.define('google-chart', GoogleChart);
//# sourceMappingURL=google-chart.js.map
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZ29vZ2xlLWNoYXJ0LmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vZ29vZ2xlLWNoYXJ0LmpzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7Ozs7Ozs7Ozs7OztBQUFBOzs7Ozs7Ozs7Ozs7Ozs7R0FlRztBQUNILElBQUksVUFBVSxHQUFHLENBQUMsSUFBSSxJQUFJLElBQUksQ0FBQyxVQUFVLENBQUMsSUFBSSxVQUFVLFVBQVUsRUFBRSxNQUFNLEVBQUUsR0FBRyxFQUFFLElBQUk7SUFDakYsSUFBSSxDQUFDLEdBQUcsU0FBUyxDQUFDLE1BQU0sRUFBRSxDQUFDLEdBQUcsQ0FBQyxHQUFHLENBQUMsQ0FBQyxDQUFDLENBQUMsTUFBTSxDQUFDLENBQUMsQ0FBQyxJQUFJLEtBQUssSUFBSSxDQUFDLENBQUMsQ0FBQyxJQUFJLEdBQUcsTUFBTSxDQUFDLHdCQUF3QixDQUFDLE1BQU0sRUFBRSxHQUFHLENBQUMsQ0FBQyxDQUFDLENBQUMsSUFBSSxFQUFFLENBQUMsQ0FBQztJQUM3SCxJQUFJLE9BQU8sT0FBTyxLQUFLLFFBQVEsSUFBSSxPQUFPLE9BQU8sQ0FBQyxRQUFRLEtBQUssVUFBVTtRQUFFLENBQUMsR0FBRyxPQUFPLENBQUMsUUFBUSxDQUFDLFVBQVUsRUFBRSxNQUFNLEVBQUUsR0FBRyxFQUFFLElBQUksQ0FBQyxDQUFDOztRQUMxSCxLQUFLLElBQUksQ0FBQyxHQUFHLFVBQVUsQ0FBQyxNQUFNLEdBQUcsQ0FBQyxFQUFFLENBQUMsSUFBSSxDQUFDLEVBQUUsQ0FBQyxFQUFFO1lBQUUsSUFBSSxDQUFDLEdBQUcsVUFBVSxDQUFDLENBQUMsQ0FBQztnQkFBRSxDQUFDLEdBQUcsQ0FBQyxDQUFDLEdBQUcsQ0FBQyxDQUFDLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQyxDQUFDLENBQUMsR0FBRyxDQUFDLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQyxNQUFNLEVBQUUsR0FBRyxFQUFFLENBQUMsQ0FBQyxDQUFDLENB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