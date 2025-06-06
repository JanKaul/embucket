from typing import Union
from slt_runner.statement import Query, Statement
from slt_runner.logger import logger

class SQLLogicTestLogger:
    def __init__(self, context, command: Union[Query, Statement], file_name: str):
        self.file_name = file_name
        self.context = context
        self.query_line = command.query_line
        self.sql_query = command.get_one_liner()

    def _build_output(self, parts):
        """Build output string from parts list"""
        return '\n'.join(parts) if isinstance(parts, list) else str(parts)

    def display_error(self, error_message):
        """Display error message in the terminal"""
        print(error_message)
        return error_message

    def print_expected_result(self, values, columns, row_wise):
        logger.debug(f'{columns}, {values}')
        if row_wise:
            for value in values:
                print(value)
        else:
            c = 0
            for value in values:
                if c != 0:
                    print("\t", end="")
                print(value, end="")
                c += 1
                if c >= columns:
                    c = 0
                    print()

    def print_line_sep(self):
        return "=" * 80

    def get_sql(self) -> str:
        query = self.sql_query.strip()
        if not query.endswith(";"):
            query += ";"
        return query

    def print_error_header(self, description):
        parts = []
        parts.append("")
        parts.append(self.print_line_sep())
        parts.append(f"{description} ({self.file_name}:{self.query_line})!")
        return '\n'.join(parts)

    def unexpected_failure(self, error):
        parts = []
        parts.append(self.print_error_header(f"Query unexpectedly failed!"))
        parts.append(self.print_line_sep())
        parts.append(str(error))
        parts.append(self.print_line_sep())
        parts.append(self.get_sql())
        parts.append(self.print_line_sep())
        error_message = '\n'.join(parts)
        return self.display_error(error_message)

    def expected_failure_with_wrong_error(self, expected_error, actual_error):
        parts = []
        parts.append(self.print_error_header(f"Query failed with unexpected error!"))
        parts.append(self.print_line_sep())
        parts.append(self.get_sql())
        parts.append(self.print_line_sep())
        parts.append('Expected error:')
        parts.append(str(expected_error))
        parts.append(self.print_line_sep())
        parts.append('Actual error:')
        parts.append(str(actual_error))
        parts.append(self.print_line_sep())
        error_message = '\n'.join(parts)
        return self.display_error(error_message)

    def no_error_but_expected(self, expected_error):
        parts = []
        parts.append(self.print_error_header(f"Query did not fail, but expected error!"))
        parts.append(self.print_line_sep())
        parts.append(self.get_sql())
        parts.append(self.print_line_sep())
        parts.append('Expected error:')
        parts.append(str(expected_error))
        parts.append(self.print_line_sep())
        error_message = '\n'.join(parts)
        return self.display_error(error_message)

    def output_hash(self, hash_value):
        parts = []
        parts.append(self.print_line_sep())
        parts.append(self.get_sql())
        parts.append(self.print_line_sep())
        parts.append(hash_value)
        parts.append(self.print_line_sep())
        error_message = '\n'.join(parts)
        return self.display_error(error_message)

    def column_count_mismatch(self, result, result_values_string, expected_column_count):
        parts = []
        parts.append(self.print_error_header("Wrong column count in query!"))
        parts.append(
            f"Expected {expected_column_count} columns, but got {result.column_count} columns"
        )
        parts.append(self.print_line_sep())
        parts.append(self.get_sql())
        parts.append(self.print_line_sep())

        # Add expected result section
        parts.append("Expected result:")

        if result_values_string:
            parts.extend(result_values_string)
        else:
            parts.append(f"(Expected schema with {expected_column_count} columns)")
            parts.append("(No expected values provided)")

        # Add line separator
        parts.append(self.print_line_sep())

        # Add actual result section
        parts.append("Actual result:")

        if result._result and len(result._result) > 0:
            actual_lines = ['\t'.join(r) for r in result._result]
            parts.extend(actual_lines)
        else:
            parts.append("(No result rows)")
            parts.append(self.print_line_sep())

        parts.append("")
        error_message = '\n'.join(parts)
        return self.display_error(error_message)

    def not_cleanly_divisible(self, expected_column_count, actual_column_count):
        parts = []
        parts.append(self.print_error_header("Error in test!"))
        parts.append(f"Expected {expected_column_count} columns, but {actual_column_count} values were supplied")
        parts.append("This is not cleanly divisible (i.e. the last row does not have enough values)")
        error_message = '\n'.join(parts)
        return self.display_error(error_message)

    def wrong_row_count(self, expected_rows, result_values_string, comparison_values, expected_column_count, row_wise):
        parts = []
        parts.append(self.print_error_header("Wrong row count in query!"))
        row_count = len(result_values_string)
        parts.append(
            f"Expected {int(expected_rows)} rows, but got {row_count} rows"
        )
        parts.append(self.print_line_sep())
        parts.append(self.get_sql())
        parts.append(self.print_line_sep())

        # Add expected results
        parts.append("Expected result:")
        expected_output = []
        self._format_expected_result(expected_output, comparison_values, expected_column_count, row_wise)
        parts.extend(expected_output)

        # Add actual results
        parts.append(self.print_line_sep())
        parts.append("Actual result:")
        actual_output = []
        self._format_expected_result(actual_output, result_values_string, expected_column_count, False)
        parts.extend(actual_output)
        parts.append(self.print_line_sep())
        error_message = '\n'.join(parts)
        return self.display_error(error_message)

    # Helper for formatting results without printing
    def _format_expected_result(self, output_list, values, columns, row_wise):
        if row_wise:
            for value in values:
                output_list.append(value)
        else:
            line = ""
            c = 0
            for value in values:
                if c != 0:
                    line += "\t"
                line += str(value)
                c += 1
                if c >= columns:
                    c = 0
                    output_list.append(line)
                    line = ""
            if line:
                output_list.append(line)

    def column_count_mismatch_correct_result(self, original_expected_columns, expected_column_count, result):
        parts = []
        parts.append(self.print_line_sep())
        parts.append(self.print_error_header("Wrong column count in query!"))
        parts.append(
            f"Expected {original_expected_columns} columns, but got {expected_column_count} columns"
        )
        parts.append(self.print_line_sep())
        parts.append(self.get_sql())
        parts.append(f"The expected result matched the query result.")
        parts.append(
            f"Suggested fix: modify header to \"query {'I' * result.column_count}\""
        )
        parts.append(self.print_line_sep())
        error_message = '\n'.join(parts)
        return self.display_error(error_message)

    def split_mismatch(self, row_number, expected_column_count, split_count):
        parts = []
        parts.append(self.print_line_sep())
        parts.append(self.print_error_header(
            f"Error in test! Column count mismatch after splitting on tab on row {row_number}!"))
        parts.append(
            f"Expected {int(expected_column_count)} columns, but got {split_count} columns"
        )
        parts.append("Does the result contain tab values? In that case, place every value on a single row.")
        parts.append(self.print_line_sep())
        error_message = '\n'.join(parts)
        return self.display_error(error_message)

    def wrong_result_query(self, expected_values, result_values_string, expected_column_count, err_msg, row_wise):
        parts = []
        parts.append(self.print_error_header("Wrong result in query!"))
        parts.append(self.print_line_sep())
        parts.append(self.get_sql())
        parts.append(self.print_line_sep())
        parts.append(err_msg)
        parts.append(self.print_line_sep())

        # Format expected results
        parts.append("Expected result:")
        expected_output = []
        self._format_expected_result(expected_output, expected_values, expected_column_count, row_wise)
        parts.extend(expected_output)

        # Format actual results
        parts.append(self.print_line_sep())
        parts.append("Actual result:")
        actual_output = []
        self._format_expected_result(actual_output, result_values_string, expected_column_count, False)
        parts.extend(actual_output)

        parts.append(self.print_line_sep())
        error_message = '\n'.join(parts)
        return self.display_error(error_message)

    def wrong_result_hash(self, expected_hash, actual_hash):
        parts = []
        parts.append(self.print_error_header("Wrong result hash!"))
        parts.append(self.print_line_sep())
        parts.append(self.get_sql())
        parts.append(self.print_line_sep())

        parts.append("Expected result:")
        parts.append(str(expected_hash))

        parts.append("Actual result:")
        parts.append(str(actual_hash))

        # Add a comparison check for debugging
        if expected_hash == actual_hash:
            parts.append(self.print_line_sep())
            parts.append("NOTE: The hash values are identical. This may be a false positive error.")

        error_message = '\n'.join(parts)
        return self.display_error(error_message)