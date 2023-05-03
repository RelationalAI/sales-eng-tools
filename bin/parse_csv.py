#!/usr/bin/env python3

import sys
import argparse
import csv

# see dialect parameter descriptions here:
# https://docs.python.org/3/library/csv.html#csv.Dialect
def dump_dialect (dialect: csv.Dialect):
    print(
        "delimiter = %s\n"
        "escapechar = %s\n"
        "quotechar = %s\n"
        "doublequote = %s\n"
        "lineterminator = %s\n"
        "skipinitialspace = %s\n"
        "strict = %s\n"
        % (
            repr(dialect.delimiter),
            dialect.escapechar,
            dialect.quotechar,
            dialect.doublequote,
            repr(dialect.lineterminator),
            repr(dialect.skipinitialspace),
            repr(dialect.strict),
        )
    )

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--file', type=str, metavar='PATH', required=True, help='file to parse')
    parser.add_argument('--top', type=int, metavar='N', required=False, default=10, help='top N lines to print [%(default)d]')
    parser.add_argument('--line', type=int, metavar='NUM', required=False, default=-1, help='0-origin line number to print [%(default)d]')
    parser.add_argument('--sniff', type=int, metavar='BYTES', required=False, default=0, help='number of bytes to sniff for Dialect [%(default)d]')
    parser.add_argument('--maxlen', type=int, metavar='BYTES', required=False, default=0, help='max number of bytes in field [131072]')
    parser.add_argument('--col', type=str, metavar='COL', required=False, nargs='+', default=[], help='column name(s) to print [%(default)s]')
    parser.add_argument('--full', action='store_true', help='show full row (all columns) [%(default)s]')
    parser.add_argument('--meta', action='store_true', help='show metadata only [%(default)s]')
    parser.add_argument('--dialect',type=str, metavar='NAME', required=False, default=None, help='dialect name ["%(default)s"]')
    parser.add_argument('--show_dialects', action='store_true', help='dump dialect info ["%(default)s"]')
    parser.add_argument('--esc', type=str, metavar='CHAR', required=False, default=None, help='escape char ["%(default)s"]')
    parser.add_argument('--no_doublequote', action='store_false', help='turn off doublequote support [DQ enabled]')
    args = parser.parse_args()

    if args.show_dialects:
        for x in csv.list_dialects():
            print("*** dialect: '%s'" % x)
            dump_dialect(csv.get_dialect(x))
        sys.exit(0)

    input_file = args.file
    line_num = args.line
    top_n = args.top
    sniff_len = args.sniff
    max_len = args.maxlen
    col_names = args.col
    full_row = args.full
    meta = args.meta

    dialect_name = args.dialect
    escape_char = args.esc
    quote_char = '"'
    dq = args.no_doublequote        # seems opposite, but parser default is True, presence of option => False

    if max_len > 0:                 # default field size limit is 128KB (131072)
        csv.field_size_limit(max_len)

    # parse the CSV
    csv_file = open(input_file)
    if sniff_len > 0:
        dialect = csv.Sniffer().sniff(csv_file.read(sniff_len))
        dump_dialect(dialect)
    else:
        if dialect_name != None:
            reader = csv.DictReader(csv_file, dialect=csv.get_dialect(dialect_name))
            dump_dialect(reader.dialect)
        else:
            reader = csv.DictReader(csv_file, escapechar=escape_char, quotechar=quote_char, doublequote=dq)
            # dump_dialect(reader.dialect)      # apparently there's no internal dialect for these ad hoc choices

        for n, row in enumerate(reader):
            if line_num >= 0 and n != line_num:
                continue
            print("-------------")
            if full_row:
                # print("[%d]" % n, row)
                for col in reader.fieldnames:
                    field = row[col]
                    if meta:
                        print("[%d] <<%d>> %s" % (n, len(field), col))
                    else:
                        print("[%d] <<%d>> %s:" % (n, len(field), col), repr(field))
            for col in col_names:
                field = row[col]
                if meta:
                    print("[%d] <<%d>> %s" % (n, len(field), col))
                else:
                    print("[%d] <<%d>> %s:" % (n, len(field), col), repr(field))
            if line_num >= 0 and n == line_num: # no point reading the rest of the file
                break
            if n >= top_n:                      # if no specific line number requested, stop after top N rows
                break

    csv_file.close()
    sys.exit(0)

if __name__ == "__main__":
    main()
