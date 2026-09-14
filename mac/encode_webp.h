#pragma once
#include <stddef.h>
#include <stdint.h>

int webp_encode_rgba(const uint8_t *rgba, int width, int height, int stride,
                     float quality, uint8_t **out, size_t *out_len);
void webp_free(uint8_t *ptr);
