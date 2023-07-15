#ifndef __IMAGE_MODEL_H_
#define __IMAGE_MODEL_H_

#include <QAbstractListModel>
#include <QObject>
#include <QUrl>
#include <iostream>

#include <opencv2/opencv.hpp>

class ImageModel : public QAbstractListModel {
    Q_OBJECT
  public:
    enum INFO_TYPE { FileName = Qt::UserRole + 1 };
    explicit ImageModel(QObject *parent = nullptr);
    ~ImageModel();
    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    Q_INVOKABLE void recurseImg(const QString &folderUrl, const int imgWidth, const int imgHeight);
    Q_INVOKABLE void emplace_back(const QString &fileName);
    Q_INVOKABLE int erase(const QString &fileName);
    Q_INVOKABLE void erase(const int locIndex);
    Q_INVOKABLE const QList<QString> imgPaths() { return m_imgs; }

  private:
    QList<QString> m_imgs;
    QHash<int, QByteArray> m_roleNames;
};

#endif // __IMAGE_MODEL_H_
