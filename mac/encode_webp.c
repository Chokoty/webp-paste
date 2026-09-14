#include "encode_webp.h"
#include <webp/encode.h>

int webp_encode_rgba(const uint8_t *rgba, int width, int height, int stride,
                     float quality, uint8_t **out, size_t *out_len) {
  uint8_t *buf = NULL;
  size_t n = WebPEncodeRGBA(rgba, width, height, stride, quality, &buf);
  if (n == 0 || buf == NULL) {
    return -1;
  }
  *out = buf;
  *out_len = n;
  return 0;
}

void webp_free(uint8_t *ptr) { WebPFree(ptr); }
