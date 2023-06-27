#ifndef PAINTITEM_H
#define PAINTITEM_H

#include <QImage>
#include <QQuickItem>
#include <QQuickWindow>
#include <QSGNode>
#include <QSGSimpleRectNode>
#include <QSGSimpleTextureNode>
#include <opencv2/opencv.hpp>

class PaintItem : public QQuickItem {
    Q_OBJECT
  public:
    explicit PaintItem(QQuickItem *parent = nullptr);
  public slots:
    void updateImage(const QImage &image);

  protected:
    QSGNode *updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *) override;

  private:
    QImage m_imageThumb;
};

#endif // PAINTITEM_H
