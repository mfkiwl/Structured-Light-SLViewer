#include "imagePaintItem.h"

ImagePaintItem::ImagePaintItem(QQuickItem *parent) : QQuickItem(parent) {
    setFlag(ItemHasContents, true);
    //m_imageThumb = new QImage(200, 200, QImage::Format_RGB32);
    //m_imageThumb->fill(QColor(48, 48, 48);
}

void ImagePaintItem::updateImage(const QImage &image) {
    m_imageThumb = image;
    update();
}

QSGNode *ImagePaintItem::updatePaintNode(QSGNode *oldNode,
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
