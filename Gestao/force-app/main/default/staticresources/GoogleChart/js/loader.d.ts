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
interface LoadSettings {
    version?: string;
    packages?: string[];
    language?: string;
    mapsApiKey?: string;
}
/**
 * Loads Google Charts API with the selected settings or using defaults.
 *
 * The following settings are available:
 * - version: which version of library to load, default: 'current',
 * - packages: which chart packages to load, default: ['corechart'],
 * - language: what language to load library in, default: `lang` attribute on
 *   `<html>` or 'en' if not specified,
 * - mapsApiKey: key to use for maps API.
 */
export declare function load(settings?: LoadSettings): Promise<void>;
/** Types that can be converted to `DataTable`. */
export declare type DataTableLike = unknown[][] | {
    cols: unknown[];
    rows?: unknown[][];
} | google.visualization.DataTable;
/**
 * Creates a DataTable object for use with a chart.
 *
 * Multiple different argument types are supported. This is because the
 * result of loading the JSON data URL is fed into this function for
 * DataTable construction and its format is unknown.
 *
 * The data argument can be one of a few options:
 *
 * - null/undefined: An empty DataTable is created. Columns must be added
 * - !DataTable: The object is simply returned
 * - {{cols: !Array, rows: !Array}}: A DataTable in object format
 * - {{cols: !Array}}: A DataTable in object format without rows
 * - !Array<!Array>: A DataTable in 2D array format
 *
 * Un-supported types:
 *
 * - Empty !Array<!Array>: (e.g. `[]`) While technically a valid data
 *   format, this is rejected as charts will not render empty DataTables.
 *   DataTables must at least have columns specified. An empty array is most
 *   likely due to a bug or bad data. If one wants an empty DataTable, pass
 *   no arguments.
 * - Anything else
 *
 * See <a
 * href="https://developers.google.com/chart/interactive/docs/reference#datatable-class">the
 * docs</a> for more details.
 *
 * @param data The data which we should use to construct new DataTable object
 */
export declare function dataTable(data: DataTableLike | undefined): Promise<google.visualization.DataTable>;
/**
 * Creates new `ChartWrapper`.
 * @param container Element in which the chart will be drawn
 */
export declare function createChartWrapper(container: HTMLElement): Promise<google.visualization.ChartWrapper>;
export {};
//# sourceMappingURL=loader.d.ts.map