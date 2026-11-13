# Getter for treatment arm names

Getter for treatment arm names

## Usage

``` r
get_arm_names(input)
```

## Arguments

- input:

  A list of parameters or model results.

## Value

A character vector of treatment arm names.

## Examples

``` r
data(base_params)
get_arm_names(base_params)
#> [1] "without_drug" "with_drug"   
```
