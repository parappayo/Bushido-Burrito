
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <malloc.h>

typedef char* (*strstr_signature)(const char*, const char*);

void print_int_array(int arr[], unsigned int len)
{
	for (unsigned int i = 0; i < len; i++)
	{
		if (i == 0) {
			printf("%d", arr[i]);
		} else {
			printf(", %d", arr[i]);
		}
	}
}

char* brute_strstr(const char* source, const char* target)
{
	unsigned int source_length = strlen(source);
	unsigned int target_length = strlen(target);

	if (target_length > source_length) { return NULL; }
	if (target_length < 1) { return (char*) source; }

	unsigned int source_index = 0;
	unsigned int target_index = 0;

	while (source_index + target_index < source_length) {

		if (target[target_index] == source[source_index + target_index]) {

			if (target_index == target_length - 1) {
				return (char*) source + source_index;
			}
			target_index++;

		} else {
			source_index++;
			target_index = 0;			
		}
	}

	return NULL;
}

/// requires that search string and table are the same length
void knuth_morris_pratt_table(const char* search_str, int table[])
{
	unsigned int search_len = strlen(search_str);
	if (search_len < 1) { return; }
	table[0] = -1;
	if (search_len < 2) { return; }
	table[1] = 0;

	unsigned int search_index = 2;
	unsigned int candidate_index = 0;

	while (search_index < search_len) {

		if (search_str[search_index - 1] == search_str[candidate_index]) {
			table[search_index] = candidate_index + 1;
			candidate_index++;
			search_index++;

		} else if (candidate_index > 0) {
			candidate_index = table[candidate_index];

		} else {
			table[search_index] = 0;
			search_index++;
		}
	}
}

void test_knuth_morris_pratt_table(char test_str[], unsigned int test_len, int table[], int expected_table[])
{
	knuth_morris_pratt_table(test_str, table);

	printf("expected: ");
	print_int_array(expected_table, test_len);

	printf("\nresult:   ");
	print_int_array(table, test_len);
	printf("\n");
}

void run_knuth_morris_pratt_tests()
{
	char test_1[] = "ABCDABD";
	const unsigned int test_1_len = sizeof(test_1) - 1;
	int table_1[test_1_len];
	int expected_table_1[] = { -1, 0, 0, 0, 0, 1, 2 };

	test_knuth_morris_pratt_table(test_1, test_1_len, table_1, expected_table_1);

	char test_2[] = "participate in parachute";
	const unsigned int test_2_len = sizeof(test_2) - 1;
	int table_2[test_2_len];
	int expected_table_2[] = { -1, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 1, 2, 3, 0, 0, 0, 0, 0 };

	test_knuth_morris_pratt_table(test_2, test_2_len, table_2, expected_table_2);
}

/// https://en.wikipedia.org/wiki/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm
char* knuth_morris_pratt_strstr(const char* source, const char* target)
{
	unsigned int source_length = strlen(source);
	unsigned int target_length = strlen(target);

	if (target_length > source_length) { return NULL; }
	if (target_length < 1) { return (char*) source; }

	int* table = malloc(target_length);
	knuth_morris_pratt_table(target, table);

	unsigned int source_index = 0;
	unsigned int target_index = 0;

	while (source_index + target_index < source_length) {

		if (target[target_index] == source[source_index + target_index]) {

			if (target_index == target_length - 1) {
				free(table);
				return (char*) source + source_index;
			}
			target_index++;

		} else {

			if (table[target_index] > -1) {
				source_index = source_index + target_index - table[target_index];
				target_index = table[target_index];

			} else {
				source_index++;
				target_index = 0;
			}
		}
	}

	free(table);
	return NULL;
}

void run_test(	const char* test_name,
				strstr_signature strstr_clone,
				const char* sample_text,
				const char* search_text )
{
	const char* result = strstr_clone(sample_text, search_text);

	printf("\t%s:\t", test_name);
	if (result)	{
		int result_index = result - sample_text;
		printf("found result at %d\n", result_index);
	} else {
		printf("no result found\n");
	}
}

void run_tests(	const char* test_names[],
				strstr_signature strstr_clones[],
				unsigned int test_count,
				const char* sample_text[],
				unsigned int sample_count,
				const char* search_text[],
				unsigned int search_count )
{
	for (unsigned int sample_index = 0; sample_index < sample_count; sample_index++)
	{
		const char* sample = sample_text[sample_index];
		printf("\ntesting sample: %s\n", sample);

		for (unsigned int search_index = 0; search_index < search_count; search_index++) {
			const char* search = search_text[search_index];
			printf("\n\ttesting search: %s\n", search);

			for (unsigned int test_index = 0; test_index < test_count; test_index++) {
				run_test(	test_names[test_index],
							strstr_clones[test_index],
							sample,
							search);
			}
		}
	}
}


int main()
{
	const char* names[] = {
		"stdlib",
		"brute",
		"k-m-p"
	};
	strstr_signature strstr_clones[] = {
		strstr,
		brute_strstr,
		knuth_morris_pratt_strstr
	};
	unsigned int test_count = sizeof(names) / sizeof(const char*);

	const char* samples[] = {
		"abara cadabera",
		"just some test text",
		"nothing to see here",
		"bar",
		""
	};
	unsigned int sample_count = sizeof(samples) / sizeof(const char*);

	const char* searches[] = {
		"bar",
		"test",
		"bogus",
		""
	};
	unsigned int search_count = sizeof(searches) / sizeof(const char*);

	printf("found %d tests and %d samples\n", test_count, sample_count);
	run_tests(names, strstr_clones, test_count, samples, sample_count, searches, search_count);
	return 0;
}
