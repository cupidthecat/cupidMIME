#ifndef CM_AUDIO_INTERNAL_H
#define CM_AUDIO_INTERNAL_H
#include "cupidmime.h"
/* Return nonzero when a native FLAC or Ogg signature claims this input. */
int cm_audio_detect(const unsigned char *p, size_t n, cm_result *r);
#endif
