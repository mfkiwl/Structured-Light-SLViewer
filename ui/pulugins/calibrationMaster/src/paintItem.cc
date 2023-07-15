#include "CalibrationMaster/include/paintItem.h"

PaintItem::PaintItem(QQuickItem *parent) : QQuickItem(parent) {
    setFlag(ItemHasContents, true);
    cv::Mat img(1280, 1024, CV_8UC3, cv::Scalar(48, 48, 48));
    m_imageThumb =
        QImage(img.data, img.cols, img.rows, QImage::Format_BGR30).copy();
}

void PaintItem::updateImage(const QImage &image) {
    m_imageThumb = image;
    update();
}

QSGNode *PaintItem::updatePaintNode(QSGNode *oldNode,
                                    QQuickItem::UpdatePaintNodeData *) {
    auto node = dynamic_cast<QSGSimpleTextureNode *>(oldNode);

    if (!node)
        node = new QSGSimpleTextureNode();

    QSGTexture *texture = window()->createTextureFromImage(
        m_imageThumb, QQuickWindow::TextureIsOpaque);
    node->setOwnsTexture(true);
    node->setRect(boundingRect());
    node->markDirty(QSGNode::DirtyForceUpdate);
    node->setTexture(texture);

    return node;
}
