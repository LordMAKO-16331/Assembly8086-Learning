
#include <stdio.h>

int main(void)
{
    int i;
    int j;

    printf("The 9*9 table:\n");

    // 外层循环控制行：从9递减到1
    for (i = 9; i >= 1; i--)
    {
        // 内层循环控制列：从1递增到当前行的乘数
        for (j = 1; j <= i; j++)
        {
            printf("%d*%d=%d   ", i, j, i * j);
        }

        // 当前行输出完毕，换行
        printf("\n");
    }

    return 0;
}
