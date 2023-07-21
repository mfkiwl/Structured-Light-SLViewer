#ifndef CALIPACKER_H
#define CALIPACKER_H

#include "typeDef.h"

class CaliPacker {
  public:
    CaliPacker();
    ~CaliPacker();
    void bundleCaliInfo(CaliInfo &info);
    void readIntrinsic();
    void writeCaliInfo(const CaliType &caliType);

  private:
    CaliInfo *m_bundleInfo;
};

#endif // CALIPACKER_H
