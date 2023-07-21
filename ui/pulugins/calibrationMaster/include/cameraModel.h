#ifndef CAMERAMODEL_H
#define CAMERAMODEL_H

#include <QAbstractListModel>
#include <QObject>
#include <QUrl>
#include <iostream>
#include <opencv2/opencv.hpp>

class CameraModel : public QAbstractListModel {
    Q_OBJECT
  public:
    enum INFO_TYPE { FileName = Qt::UserRole + 1 };
    explicit CameraModel(QObject *parent = nullptr);
    ~CameraModel();
    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    Q_INVOKABLE void recurseImg(const QUrl &folderUrl);
    Q_INVOKABLE void emplace_back(const QString &fileName);
    Q_INVOKABLE int erase(const QString &fileName);
    Q_INVOKABLE void erase(const int locIndex);
    Q_INVOKABLE const QList<QString> imgPaths() { return m_imgs; }

  private:
    QList<QString> m_imgs;
    QHash<int, QByteArray> m_roleNames;
};

#endif // CAMERAMODEL_H
