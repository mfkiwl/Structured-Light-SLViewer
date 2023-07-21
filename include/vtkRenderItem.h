#ifndef __VTK_RENDER_ITEM_H_
#define __VTK_RENDER_ITEM_H_

#include <future>
#include <queue>

#include <QQuickVTKRenderItem.h>
#include <QQuickVTKRenderWindow.h>
#include <vtkRenderWindow.h>
#include <vtkUnsignedCharArray.h>

class VTKRenderItem : public QQuickVTKRenderItem {
    Q_OBJECT
public:
    VTKRenderItem();
    template<class F, class... Args>
    std::future<void>& pushCommandToQueue(F&& f, Args&&... args)
    {
        using return_type = typename std::result_of<F(Args...)>::type;

        auto task = std::make_shared< std::packaged_task<return_type()> >(
                    std::bind(std::forward<F>(f), std::forward<Args>(args)...)
                    );

        std::future<return_type> res = task->get_future();
        {
            __commandQueue.emplace([task]() { (*task)(); });
        }
        return res;
    }
public slots:
    void sync() override;
private:
    std::queue<std::function<void()>> __commandQueue;
    vtkNew<vtkUnsignedCharArray> __pixelArray;
};

#endif //__VTK_RENDER_ITEM_H_
