#ifndef __IMAGE_PAINTITEM_H_
#define __IMAGE_PAINTITEM_H_

#include <QImage>
#include <QQuickItem>
#include <QQuickWindow>
#include <QSGNode>
#include <QSGSimpleRectNode>
#include <QSGSimpleTextureNode>

#include <opencv2/opencv.hpp>

class ImagePaintItem : public QQuickItem {
    Q_OBJECT
  public:
    explicit ImagePaintItem(QQuickItem *parent = nullptr);
  public slots:
    void updateImage(const QImage &image);

  protected:
    QSGNode *updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *) override;

  private:
    QImage m_imageThumb;
};

#endif // __IMAGE_PAINTITEM_H_
