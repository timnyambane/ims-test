<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Worker extends Model
{
    protected $fillable = [
        'name',
        'email',
    ];

    public function tasks(): HasMany
    {
        return $this->hasMany(Task::class);
    }
}
